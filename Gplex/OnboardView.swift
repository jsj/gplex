//
//  ContentView.swift
//  Gplex
//
//  Created by James Jackson on 7/21/23.
//

import SwiftUI

struct OnboardView: View {
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Image("onboard-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .padding(.top, 32)
                VStack(spacing: 10) {
                    Text("Enable Gplex")
                        .textCase(.uppercase)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .fontWeight(.semibold)
                }
                .padding()
            }
            VStack(spacing: 25) {
                VStack {
                    HStack {
                        Image(systemName: "1.circle.fill")
                            .foregroundColor(Color(red: 0.98, green: 0.73, blue:  0.02))
                        Text("Go to **Settings**")
                    }
                    Button {
                        openURL(URL(string: "App-Prefs:SAFARI&path=WEB_EXTENSIONS/Safari")!)
                    } label: {
                        HStack {
                            Text("Open Safari Settings")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .padding()
                        }
                    }
                    .background {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white,
                                Color(red: 0.98, green: 0.73, blue:  0.02)
                            ]),
                            startPoint: .init(x: 0, y: -10),
                            endPoint: .bottom
                        )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                    .padding()
                }
                VStack {
                    HStack {
                        Image(systemName: "2.circle.fill")
                            .foregroundColor(Color(red: 0.98, green: 0.73, blue:  0.02))
                        Text("Toggle the extension **On**")
                    }
                    Image("onboard-2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                }
                VStack {
                    HStack {
                        Image(systemName: "3.circle.fill")
                            .foregroundColor(Color(red: 0.98, green: 0.73, blue:  0.02))
                        Text("Under Permissions, tap **google.com**")
                    }
                    Image("onboard-3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                }
                VStack {
                    HStack {
                        Image(systemName: "4.circle.fill")
                            .foregroundColor(Color(red: 0.98, green: 0.73, blue:  0.02))
                        Text("From the list of options, tap **Allow**")
                    }
                    Image("onboard-4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                }
                VStack {
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "5.circle.fill")
                                .foregroundColor(Color(red: 0.98, green: 0.73, blue:  0.02))
                            Text("Tap **GENERATE ✨** from a search result to complete setup")
                        }
                        Button {
                            openURL(URL(string: "https://www.google.com/search?q=who+is+the+richest+person+in+the+world")!)
                        } label: {
                            Text("Make Demo Search…")
                                .bold()
                        }
                    }
                    Image("onboard-5")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                }
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}
