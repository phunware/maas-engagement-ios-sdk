//
//  MessageDetailViewController.swift
//  EngagementSample
//
//  Created on 8/10/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import PWEngagement

extension PWMEZoneMessage {
    
    func formattedTimestamp() -> String? {
        var formattedTimestamp: String?
        guard let timestamp = timestamp else {
            return formattedTimestamp
        }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formattedTimestamp = timeFormatter.string(from: timestamp)
        return formattedTimestamp
    }
}

class MessageDetailViewController: UIViewController {
    
    var message: PWMEZoneMessage!
    
    @IBOutlet weak var rawDataLabel: UILabel!
    @IBOutlet weak var webContentView: UIView!
    var previewWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()

        if message.isRead == false {
            message.read()
        }
        let titleAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]
        let valueAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: UIFont.systemFontSize), NSAttributedString.Key.foregroundColor : UIColor.gray]
        let text = NSMutableAttributedString(string: "", attributes: titleAttributes)
        
        if let messageId = message.identifier {
            text.append(NSAttributedString(string: "Message ID:\n", attributes: titleAttributes))
            text.append(NSAttributedString(string: messageId, attributes: valueAttributes))
        }
        text.append(NSAttributedString(string: "\nType:\n", attributes: titleAttributes))
        text.append(NSAttributedString(string: message.campaignType, attributes: valueAttributes))
        
        if let formattedTimestamp = message.formattedTimestamp() {
            text.append(NSAttributedString(string: "\nReceived at:\n", attributes: titleAttributes))
            text.append(NSAttributedString(string: formattedTimestamp, attributes: valueAttributes))
        }
        text.append(NSAttributedString(string: "\nAlert title:\n", attributes: titleAttributes))
        text.append(NSAttributedString(string: message.alertTitle, attributes: valueAttributes))
        text.append(NSAttributedString(string: "\nAlert body:\n", attributes: titleAttributes))
        text.append(NSAttributedString(string: message.alertBody, attributes: valueAttributes))
        
        if message.metaData.count > 0 {
            text.append(NSAttributedString(string: "\nMeta data:\n", attributes: titleAttributes))
            text.append(NSAttributedString(string: String(describing: message.metaData), attributes: valueAttributes))
        }
        if let promotionTitle = message.promotionTitle {
            text.append(NSAttributedString(string: "\nPromotion title:\n", attributes: titleAttributes))
            text.append(NSAttributedString(string: promotionTitle, attributes: valueAttributes))
        }
        if let promotionBody = message.promotionBody {
            text.append(NSAttributedString(string: "\nPromotion body:\n", attributes: titleAttributes))
            text.append(NSAttributedString(string: promotionBody, attributes: valueAttributes))
            previewWebView.loadHTMLString(promotionBody, baseURL: nil)
        }
        rawDataLabel.attributedText = text
    }
    
    func configureWebView() {
        previewWebView = WKWebView(frame: CGRect.zero)
        previewWebView.translatesAutoresizingMaskIntoConstraints = false
        webContentView.addSubview(previewWebView)
        
        previewWebView.leadingAnchor.constraint(equalTo: webContentView.leadingAnchor).isActive = true
        previewWebView.trailingAnchor.constraint(equalTo: webContentView.trailingAnchor).isActive = true
        previewWebView.topAnchor.constraint(equalTo: webContentView.topAnchor).isActive = true
        previewWebView.bottomAnchor.constraint(equalTo: webContentView.bottomAnchor).isActive = true
    }
    
    @IBAction func remove(_ sender: UIBarButtonItem) {
        message.remove()
        self.navigationController?.popViewController(animated: true)
    }
}
