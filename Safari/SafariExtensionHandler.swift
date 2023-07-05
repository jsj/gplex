//
//  SafariExtensionHandler.swift
//  Safari Extension
//
//  Created by James Jackson on 7/15/23.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        guard let url = URL(string: "https://chat.parrotflow.com/") else { return }
        window.openTab(with: url, makeActiveIfPossible: true)
    }
}
