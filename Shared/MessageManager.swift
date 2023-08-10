//
//  MessageManager.swift
//  Parrotflow
//
//  Created by James Jackson on 7/22/23.
//

import SwiftUI

class MessageManager: ObservableObject {
    
    @Published var messages = [Query.Message]()
    @Published var currentTask: URLSessionTask?
    @Published var isFollowUpVisible: Bool = false
    
    private let parrotflowAPI = ParrotflowAPI()
    
    @MainActor
    func sendMessage(prompt: String) {
        isFollowUpVisible = false
        messages.append(Query.Message(role: "user", content: prompt))
        Task {
            do {
                let request = try self.parrotflowAPI.makeRequest(messages: messages)
                let (stream, _) = try await URLSession.shared.bytes(for: request)
                self.currentTask = stream.task
                let assistantMessage = Query.Message(role: "assistant", content: "")
                self.messages.append(assistantMessage)
                for try await line in stream.lines {
#if os(iOS)
                    UIImpactFeedbackGenerator().impactOccurred()
                    
#elseif os(macOS)
                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
#endif
                    guard let message = parrotflowAPI.parse(line) else { continue }
                    if let lastMessageIndex = self.messages.lastIndex(where: { $0.role == "assistant" }) {
                        withAnimation(.easeInOut) {
                            self.messages[lastMessageIndex].content += "\(message)"
                        }
                    }
                }
                isFollowUpVisible = true
            } catch {
                if (error.localizedDescription != "cancelled") {
                    messages.append(Query.Message(role: "assistant", content: error.localizedDescription))
                }
            }
            currentTask = nil
        }
    }
    
    func clear() {
        messages = []
        currentTask?.cancel()
        currentTask = nil
        isFollowUpVisible = false
    }
}
