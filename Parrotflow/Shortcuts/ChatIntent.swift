//
//  ChatIntent.swift
//  Parrotflow
//
//  Created by James Jackson on 7/4/23.
//

import AppIntents

struct ChatIntent: AppIntent {
    
    static var openAppWhenRun: Bool = true
    static var title: LocalizedStringResource = "Chat with Parrotflow"
    
    @Parameter(title: "Context")
    var context: String?
    
    @MainActor
    func perform() async throws -> some IntentResult {
        MessageStore.shared.context = context ?? ""
        return .result()
    }
}
