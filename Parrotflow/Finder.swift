//
//  Finder.swift
//  Parrotflow
//
//  Created by James Jackson on 7/8/23.
//

import SwiftUI
import PDFKit

class Finder {
    
    static func showOpenPanel() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.text, .plainText, .pdf]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        return openPanel.runModal() == .OK ? openPanel.url : nil
    }
    
    static func readContent(from url: URL) -> String? {
        guard url.pathExtension == "pdf",
              let pdf = PDFDocument(url: url),
              let loadedText = pdf.string else {
            do {
                return try String(contentsOf: url)
            } catch {
                return nil
            }
        }
        return loadedText
    }
}
