//
//  SafariExtensionHandler.swift
//  Gplex
//
//  Created by James Jackson on 7/15/23.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func toolbarItemClicked(in window: SFSafariWindow) { 
        guard let url = URL(string: "https://perplexity.ai/search?q=who+is+the+richest+person+in+the+world") else { return }
        NSWorkspace.shared.open(url)
    }
}
