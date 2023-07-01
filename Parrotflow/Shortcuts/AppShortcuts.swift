//
//  AppIntents.swift
//  Parrotflow
//
//  Created by James Jackson on 7/4/23.
//

import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    
    static var shortcutTileColor: ShortcutTileColor = .orange
    
    static var appShortcuts: [AppShortcut] = [
        AppShortcut(
            intent: ChatIntent(),
            phrases: [
                "Chat with \(.applicationName)",
            ],
            shortTitle: "Chat",
            systemImageName: "arrow.down.message"
        )
    ]
}
