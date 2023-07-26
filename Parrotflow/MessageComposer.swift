//
//  MessageComposer.swift
//  Parrotflow
//
//  Created by James Jackson on 7/26/23.
//

import SwiftUI
import UIKit
import MessageUI

struct MessageComposer: UIViewControllerRepresentable {
    
    let recipient: String
    let message: String
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.recipients = [recipient]
        messageComposeVC.body = message
        messageComposeVC.messageComposeDelegate = context.coordinator
        return messageComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        // Update the view controller if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let parent: MessageComposer
        
        init(_ parent: MessageComposer) {
            self.parent = parent
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
        }
    }
}
