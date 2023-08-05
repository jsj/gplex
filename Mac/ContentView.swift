//
//  ContentView.swift
//  Mac
//
//  Created by James Jackson on 8/1/23.
//

import SwiftUI
import SafariServices

struct ContentView: View {
    
    static let safariExtensionID = "com.parrotflow.mac.safari"
    
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
                    Button(action: {
                        SFSafariApplication.showPreferencesForExtension(withIdentifier: Self.safariExtensionID)
                    }, label: {
                        Text("Enable Safari Extension")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .padding()
                    })
                    .buttonStyle(.plain)
                    .background {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 27 / 255, green: 192 / 255, blue: 249 / 255),
                                Color(red: 30 / 255, green: 113 / 255, blue: 242 / 255)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                    .padding()
                    ShareLink(item: URL(string: "https://parrotflow.com")!) {
                        HStack {
                            Text("Send to your iPhone")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .padding()
                        }
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
                    .padding()
                }
            }
        }
    }
}
