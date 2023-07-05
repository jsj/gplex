//
//  Parrotflow.swift
//  Parrotflow
//
//  Created by James Jackson on 7/1/23.
//

import SwiftUI

@main
struct Parrotflow: App {
    
    @Environment(\.openURL) var openURL
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .onOpenURL { url in
                    guard let content = Finder.readContent(from: url),
                          let baseURL = URL(string: "http://chat.parrotflow.com") else {
                        return
                    }
                    var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
                    let queryItem = URLQueryItem(name: "p", value: content)
                    components?.queryItems = [queryItem]
                    guard let encodedURL = components?.url else {
                        return
                    }
                    openURL(encodedURL)
                }
        }
        .commands {
            CommandGroup(before: .saveItem) {
                Button("Open File") {
                    guard let url = Finder.showOpenPanel() else { return }
                    guard let content = Finder.readContent(from: url),
                          let baseURL = URL(string: "http://chat.parrotflow.com") else {
                        return
                    }
                    var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
                    let queryItem = URLQueryItem(name: "p", value: content)
                    components?.queryItems = [queryItem]
                    guard let encodedURL = components?.url else {
                        return
                    }
                    openURL(encodedURL)
                }
                .keyboardShortcut("o", modifiers: .command)
            }
        }
    }
}
