//
//  ContentView.swift
//  Parrotflow
//
//  Created by James Jackson on 7/15/23.
//

import SwiftUI
import SafariServices
import CoreGraphics

struct ContentView: View {
    
    static let extensionID = "com.parrotflow.mac.safari"
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
            Image("Dalle")
                .resizable()
            VStack(spacing: 14) {
                Image(nsImage: NSImage(named: "AppIcon")!)
                Text("Parrotflow")
                    .textCase(.uppercase)
                    .opacity(0.5)
                    .blendMode(.plusLighter)
                HStack {
                    Button("Get Shortcut") {
                        openURL(URL(string: "http://parrotflow.com/shortcut")!)
                    }
                    .accentColor(.indigo)
                    .buttonStyle(.borderedProminent)
                    Button("Enable Safari Extension") {
                        SFSafariApplication.showPreferencesForExtension(withIdentifier: Self.extensionID)
                    }
                    .accentColor(.blue)
                    .buttonStyle(.borderedProminent)
                    Button("Open a file") {
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
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
