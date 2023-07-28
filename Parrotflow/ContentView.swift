//
//  ContentView.swift
//  Parrotflow
//
//  Created by James Jackson on 7/21/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.requestReview) var requestReview
    
    @EnvironmentObject var messageManager: MessageManager
    
    @State private var text: String = ""
    @State private var showAlert = false
    @FocusState private var isFocused: Bool
    @State private var showingOnboarding: Bool = false
     
    var body: some View {
        ZStack {
            ScrollView {
                HStack {
                    Text("Parrotflow")
                        .font(.caption2)
                        .textCase(.uppercase)
                        .opacity(0.5)
                        .contextMenu {
                            Group {
                                Button {
                                    messageManager.clear()
                                } label: {
                                    Label("Clear", systemImage: "clear")
                                }
                                ShareLink(item: URL(string: "https://parrotflow.com")!) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                Button {
                                    requestReview()
                                } label: {
                                    Label("Rate", systemImage: "star")
                                }
                                Button {
                                    openURL(URL(string: "https://www.google.com/search?q=how+tall+is+the+eiffel+tower")!)
                                } label: {
                                    Label("Demo", systemImage: "magnifyingglass")
                                }
                                Button {
                                    showingOnboarding = true
                                } label: {
                                    Label("Onboarding", systemImage: "safari")
                                }
                                Text("© 2023 James Jackson")
                                    .textCase(.uppercase)
                            }
                        }
                    Spacer()
                    Button {
                        messageManager.currentTask?.cancel()
                        messageManager.currentTask = nil
                    } label: {
                        Image(systemName: "stop.circle")
                            .font(.title)
                            .foregroundStyle(Color.pink)
                            .opacity(messageManager.currentTask == nil ? 0 : 1)
                    }
                }
                .padding()
                ForEach(messageManager.messages) { message in
                    HStack {
                        Text(message.content)
                            .opacity(message.role == "user" ? 0.5 : 1)
                            .padding()
                        Spacer()
                    }
                }
                Button {
                    UIImpactFeedbackGenerator().impactOccurred()
                    messageManager.isFollowUpVisible = false
                    isFocused = true
                    text = ""
                } label: {
                    Text("Ask a follow up")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding()
                }
                .background {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 93 / 255, green: 248 / 255, blue: 119 / 255),
                            Color(red: 20 / 255, green: 194 / 255, blue: 49 / 255)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                .opacity(messageManager.isFollowUpVisible && !isFocused ? 1 : 0)
            }
            .onTapGesture {
                text = ""
                isFocused.toggle()
            }
            VStack {
                Spacer()
                TextField("Send a message", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .background {
                        Color.black
                    }
                    .focused($isFocused)
                    .opacity(isFocused ? 1 : 0)
                    .onSubmit {
                        messageManager.sendMessage(prompt: text)
                    }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Clear"),
                      message: Text("Are you sure you want to clear the chat?"),
                      primaryButton: .destructive(Text("Clear"), action: { messageManager.clear() }),
                      secondaryButton: .cancel(Text("Cancel")))
            }
            .onShake {
                UIImpactFeedbackGenerator().impactOccurred()
                withAnimation {
                    showAlert = true
                }
            }
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingOnboarding) {
                OnboardView()
            }
        }
    }
}
