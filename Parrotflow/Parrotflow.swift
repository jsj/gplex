//
//  ParrotflowApp.swift
//  Parrotflow
//
//  Created by James Jackson on 7/21/23.
//

import SwiftUI

@main
struct Parrotflow: App {
    
    @AppStorage("hasOnboarded") var hasOnboarded = false
    @StateObject private var messageManager = MessageManager()
    
    var body: some Scene {
        WindowGroup {
            if hasOnboarded {
                ContentView()
                    .environmentObject(messageManager)
                    .preferredColorScheme(.dark)
                    .onOpenURL(perform: { url in
                        hasOnboarded = true
                        messageManager.clear()
                        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                        guard let components = components else { return }
                        guard let queryItems = components.queryItems else { return }
                        let qQueryItem = queryItems.first { queryItem in return queryItem.name == "q" }
                        guard let q = qQueryItem?.value?.replacingOccurrences(of: "+", with: " ") else { return }
                        messageManager.sendMessage(prompt: q)
                    })
            } else {
                OnboardView()
                    .preferredColorScheme(.dark)
                    .onOpenURL(perform: { url in
                        hasOnboarded = true
                        messageManager.clear()
                        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                        guard let components = components else { return }
                        guard let queryItems = components.queryItems else { return }
                        let qQueryItem = queryItems.first { queryItem in return queryItem.name == "q" }
                        guard let q = qQueryItem?.value?.replacingOccurrences(of: "+", with: " ") else { return }
                        messageManager.sendMessage(prompt: q)
                    })
            }
        }
    }
}
