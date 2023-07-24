//
//  ContentView.swift
//  Parrotflow
//
//  Created by James Jackson on 7/21/23.
//

import SwiftUI

struct OnboardView: View {
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "1.circle.fill")
                            .foregroundColor(.red)
                            .padding(.trailing)
                        Button {
                            openURL(URL(string: "App-Prefs:SAFARI&path=WEB_EXTENSIONS/Safari")!)
                        } label: {
                            HStack {
                                Text("Open Safari Extension Settings")
                                    .foregroundStyle(.white)
                                    .padding()
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                        .padding()
                    }
                } header: {
                    Text("Steps")
                }
                Section {
                    HStack {
                        Image(systemName: "2.circle.fill")
                            .foregroundColor(.yellow)
                            .padding(.trailing)
                        Spacer()
                        HStack {
                            Text("Chat with Parrotflow")
                            Spacer()
                            HStack {
                                Text("On")
                                    .foregroundColor(.yellow)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(Color(uiColor: UIColor.tertiarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    HStack {
                        Image(systemName: "3.circle.fill")
                            .foregroundColor(.green)
                            .padding(.trailing)
                        Spacer()
                        HStack {
                            Text("google.com")
                            Spacer()
                            HStack {
                                Text("Allow")
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(Color(uiColor: UIColor.tertiarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                } header: {
                    Text("Check Permissions")
                } footer: {
                    Text("Once enabled open \"Chat\" from a search result to disable onboarding.")
                }
            }
            .navigationBarTitle("Enable Parrotflow", displayMode: .inline)
        }
    }
}
