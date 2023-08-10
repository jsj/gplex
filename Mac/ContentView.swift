//
//  ContentView.swift
//  Mac
//
//  Created by James Jackson on 8/1/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.requestReview) var requestReview
    
    @EnvironmentObject var messageManager: MessageManager
    
    @State var text: String = ""
    @State var showAlert = false
    @FocusState var isFocused: Bool
    @State var showingOnboarding: Bool = false
     
    var body: some View {
        ZStack {
            ScrollView {
                HStack {
                    Text("Parrotflow")
                        .font(.caption2)
                        .textCase(.uppercase)
                        .opacity(0.5)
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
                    .buttonStyle(.plain)
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
                    messageManager.isFollowUpVisible = false
                    isFocused = true
                    text = ""
                } label: {
                    Text("Ask a follow up")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding()
                }
                .buttonStyle(.plain)
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
            .preferredColorScheme(.dark)
        }
    }
}
