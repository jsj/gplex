//
//  ContentView.swift
//  Parrotflow
//
//  Created by James Jackson on 7/21/23.
//

import SwiftUI

struct OnboardView: View {
    
    @Environment(\.openURL) var openURL
    @State private var needsHelp = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Image("onboard-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .padding(.top, 32)
                VStack(spacing: 10) {
                    Text("Enable Safari Extension")
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
                            .foregroundColor(.green)
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
                VStack {
                    HStack {
                        Image(systemName: "2.circle.fill")
                            .foregroundColor(.green)
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
                            .foregroundColor(.green)
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
                            .foregroundColor(.green)
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
                                .foregroundColor(.green)
                            Text("Tap **Chat** from a search result to complete setup and disable onboarding")
                        }
                        Button {
                            openURL(URL(string: "https://www.google.com/search?q=how+tall+is+the+eiffel+tower")!)
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
                Divider()
                VStack {
                    Button {
                        needsHelp = true
                    } label: {
                        Text("Need Help? Message Support…")
                    }
                }
            }
            .padding()
        }
        .interactiveDismissDisabled()
        .sheet(isPresented: $needsHelp) {
            MessageComposer(recipient: "contact@parrotflow.com", message: "I need help enabling Parrotflow")
        }
    }
}
