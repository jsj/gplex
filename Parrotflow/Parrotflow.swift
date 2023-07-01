//
//  Parrotflow.swift
//  Parrotflow
//
//  Created by James Jackson on 7/1/23.
//

import SwiftUI

@main
struct Parrotflow: App {
    @StateObject private var purchases = Purchases()
    @StateObject private var messageStore = MessageStore.shared
    
    var body: some Scene {
        WindowGroup {
            MessageView()
                .environmentObject(purchases)
                .environmentObject(messageStore)
                .preferredColorScheme(.dark)
        }
    }
}
