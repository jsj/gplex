//
//  MessageView.swift
//  Parrotflow
//
//  Created by James Jackson on 7/1/23.
//

import SwiftUI
import StoreKit
import PDFKit

class MessageStore: ObservableObject {
    
    static let shared = MessageStore()
    
    @Published var context = ""
    @Published var prompt = ""
    @Published var selectedPDF: URL? = nil
    
    @Published var messages = [Message]()
    @Published var usage = [String: Int]()
    
    func reset() {
        prompt = ""
        context = ""
        messages = []
        selectedPDF = nil
        usage = [String: Int]()
    }
    
    func clear() {
        messages = []
        usage = [String: Int]()
    }
    
    func requestMessages() -> [Message] {
        return [ Message(role: "user", content: context) ] + messages
    }
}

struct MessageView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var purchases: Purchases
    @EnvironmentObject var messageStore: MessageStore
    
    private let openAI = OpenAI()
    @State private var availableModels = [OpenAI.modeName]
    @State private var selectedModel = OpenAI.modeName
    
    @State private var isTrashVisible = false
    
    @State private var isWaitingForResponse = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationSplitView {
            VStack {
                List(availableModels, id: \.self, selection: $selectedModel) { model in
                    HStack {
                        Text(model)
                        Spacer()
                        Button {
                            messageStore.reset()
                        } label: {
                            Image(systemName: "trash")
                        }
                        .opacity(isTrashVisible ? 1 : 0)
                        .buttonStyle(.plain)
                    }
                    .onHover {
                        isTrashVisible = $0
                    }
                }
                VStack(spacing: 0) {
                    HStack {
                        Text("Input your data")
                            .opacity(0.5)
                            .blendMode(.plusLighter)
                        Spacer()
                    }
                    .padding(.horizontal)
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(.black)
                        .opacity(0.5)
                        .overlay {
                            if let pdf = messageStore.selectedPDF {
                                PDFDocumentView(url: pdf)
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                            } else {
                                TextEditor(text: $messageStore.context)
                                    .lineSpacing(1.25)
                                    .scrollContentBackground(.hidden)
                                    .padding()
                            }
                        }
                        .padding()
                    if purchases.hasPlus {
                        Button {
                            let fileURL = showOpenPanel()
                            readContent(from: fileURL)
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle")
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                }
            }
        } detail: {
            VStack(spacing: 0) {
                List(messageStore.messages) { message in
                    Spacer()
                    HStack {
                        if message.role == "user" {
                            Spacer()
                            Text(message.content)
                                .padding()
                                .background(purchases.hasPlus ? .blue : .green)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        } else {
                            Text(message.content)
                                .padding()
                                .background(.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            Spacer()
                        }
                    }
                    .foregroundColor(.primary)
                    .textSelection(.enabled)
                    .listRowSeparator(.hidden)
                }
                VStack(spacing: 0) {
                    ProgressView()
                        .opacity(isWaitingForResponse ? 1 : 0)
                        .progressViewStyle(.linear)
                        .padding(.horizontal)
                    TextField("Send a message", text: $messageStore.prompt)
                        .focused($isTextFieldFocused)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .onSubmit {
                            withAnimation {
                                isWaitingForResponse = true
                            }
                            messageStore.messages.append(Message(role: "user", content: messageStore.prompt))
                            Task {
                                do {
                                    let completion = try await openAI.predict(messageStore: messageStore)
                                    guard let chatbotMessage = completion.choices.first?.message else {
                                        return
                                    }
                                    messageStore.usage = completion.usage
                                    messageStore.messages.append(Message(role: chatbotMessage.role, content: chatbotMessage.content))
#if !DEBUG
                                    requestReview()
#endif
                                } catch {
                                    messageStore.messages.append(Message(role: "assistant", content: error.localizedDescription))
                                    NSSound.beep()
                                }
                                withAnimation {
                                    isWaitingForResponse = false
                                }
                            }
                        }
                }
            }
            .navigationSubtitle(purchases.hasPlus ? "Plus".uppercased() : "")
            .toolbar {
                ToolbarItemGroup {
                    Button("Clear") {
                        messageStore.clear()
                    }
                    .opacity(0)
                    .keyboardShortcut(KeyEquivalent("k"), modifiers: .command)
                    if !purchases.hasPlus {
                        Button("Upgrade") {
                            Task {
                                let _ = try await purchases.purchase(product: .plus)
                            }
                        }
                    }
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
        .background(.background)
    }
    
    func showOpenPanel() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.plainText, .pdf]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        let response = openPanel.runModal()
        return response == .OK ? openPanel.url : nil
    }
    
    func readContent(from url: URL?) {
        guard let url = url else { return }
        if url.pathExtension == "pdf" {
            guard let pdf = PDFDocument(url: url), let loadedText = pdf.string else { return }
            messageStore.context = loadedText
            messageStore.selectedPDF = url
        } else {
            guard let loadedText = try? String(contentsOf: url) else { return }
            messageStore.context = loadedText
            messageStore.selectedPDF = nil
        }
    }
}

struct PDFDocumentView: View {
    var url: URL?
    
    var body: some View {
        PDFViewRepresentable(url: url)
    }
}

struct PDFViewRepresentable: NSViewRepresentable {
    var url: URL?
    
    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView(frame: .zero)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {
        if let url = url, nsView.document?.documentURL != url {
            nsView.document = PDFDocument(url: url)
        }
    }
}
