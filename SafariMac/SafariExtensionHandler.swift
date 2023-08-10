//
//  SafariExtensionHandler.swift
//  Safari Extension
//
//  Created by James Jackson on 7/15/23.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        guard let pfURL = URL(string: "parrotflow://") else { return }
        NSWorkspace.shared.open(pfURL)
    }
}
