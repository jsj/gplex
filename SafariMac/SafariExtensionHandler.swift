//
//  SafariExtensionHandler.swift
//  Gplex
//
//  Created by James Jackson on 7/15/23.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        guard let pfURL = URL(string: "https://perplexity.ai") else { return }
        NSWorkspace.shared.open(pfURL)
    }
}
