//
//  LogsCell.swift
//  EngagementSample
//
//  Created on 8/9/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit

class LogsCell: UITableViewCell {
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configure(logItem: LogItem) {
        categoryLabel.text = nil
        detailLabel.text = logItem.dictionaryInfo.description.replacingOccurrences(of: "\n", with: " ")
        
        if let timestamp = logItem.timestamp {
            timestampLabel.text = timestamp
        }
        if let category = logItem.category {
            categoryLabel.text = category.rawValue
        }
        if let message = logItem.message {
            messageLabel.text = message
        }
        if let errorType = logItem.errorType {
            switch errorType {
            case .logTypeError:
                backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5)
            case .logTypeWarning:
                backgroundColor = UIColor(red: 231/255, green: 188/255, blue: 47/255, alpha: 0.5)
            case .logTypeInfo:
                backgroundColor = UIColor(red: 54/255, green: 95/255, blue: 56/255, alpha: 0.5)
            default:
                backgroundColor = .white
            }
        } else {
            backgroundColor = .white
        }
    }
}
