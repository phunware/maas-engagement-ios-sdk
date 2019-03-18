//
//  LogDetailViewController.swift
//  EngagementSample
//
//  Created on 8/10/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit

class LogDetailViewController: UIViewController {
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var logItem: LogItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryLabel.text = nil
        detailLabel.text = logItem.dictionaryInfo.description
        
        if let timestamp = logItem.timestamp {
            timestampLabel.text = timestamp
        }
        if let category = logItem.category {
            categoryLabel.text = category.rawValue
        }
        if let message = logItem.message {
            messageLabel.text = message
        }
    }
}
