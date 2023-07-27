//
//  ParrotflowApp.swift
//  Parrotflow
//
//  Created by James Jackson on 7/21/23.
//

import SwiftUI

@main
struct Parrotflow: App {
    
    @AppStorage("needsOnboard") var needsOnboard = true
    @StateObject private var messageManager = MessageManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(messageManager)
                .onOpenURL(perform: { url in
                    needsOnboard = false
                    messageManager.clear()
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                    guard let components = components else { return }
                    guard let queryItems = components.queryItems else { return }
                    let qQueryItem = queryItems.first { queryItem in return queryItem.name == "q" }
                    guard let q = qQueryItem?.value?.replacingOccurrences(of: "+", with: " ") else { return }
                    messageManager.sendMessage(prompt: q)
                })
                .sheet(isPresented: $needsOnboard) {
                    OnboardView()
                }
        }
    }
}
