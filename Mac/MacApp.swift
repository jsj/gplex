//
//  MacApp.swift
//  Mac
//
//  Created by James Jackson on 8/1/23.
//

import SwiftUI

@main
struct MacApp: App {
    
    @StateObject var messageManager = MessageManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(messageManager)
                .background(Color.black)
                .onOpenURL(perform: { url in
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
