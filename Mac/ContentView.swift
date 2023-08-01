//
//  ContentView.swift
//  Mac
//
//  Created by James Jackson on 8/1/23.
//

import SwiftUI

struct ContentView: View {
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
