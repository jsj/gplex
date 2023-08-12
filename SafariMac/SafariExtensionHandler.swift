//
//  SafariExtensionHandler.swift
//  Gplex
//
//  Created by James Jackson on 7/15/23.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        
        window.getActiveTab { tab in
            tab?.getActivePage(completionHandler: { page in
                page?.getPropertiesWithCompletionHandler { properties in
                    guard let urlString = properties?.url?.absoluteString else {
                        return
                    }
                    let components = URLComponents(url: URL(string: urlString)!, resolvingAgainstBaseURL: false)
                    guard let components = components else { return }
                    guard let queryItems = components.queryItems else { return }
                    let qQueryItem = queryItems.first { queryItem in return queryItem.name == "q" }
                    guard let v = qQueryItem?.value else { return }
                    guard let url = URL(string: "https://gplexapp.com/search?q=\(v)") else { return }
                    NSWorkspace.shared.open(url)
                }
            })
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        window.getActiveTab { tab in
            tab?.getActivePage(completionHandler: { page in
                page?.getPropertiesWithCompletionHandler { properties in
                    guard let urlString = properties?.url?.absoluteString else {
                        validationHandler(false, "")
                        return
                    }
                    if let url = URL(string: urlString), url.host?.hasSuffix("google.com") == true {
                        validationHandler(true, "")
                    } else {
                        validationHandler(false, "")
                    }
                }
            })
        }
    }
}
