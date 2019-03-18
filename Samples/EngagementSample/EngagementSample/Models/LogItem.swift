//
//  LogItemModel.swift
//  EngagementSample
//
//  Created on 8/13/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation


struct LogItem {
    
    enum CategoryType: String, CaseIterable {
        case general = "General"
        case network = "Network"
        case persistence = "Persistence"
        case location = "Location"
        case remote = "Remote Notifications"
        case message = "Message"
        case attribute = "Attributes"
        case beacon = "Beacon"
        case zone = "Zones"
    }
    
    enum ErrorType: String {
        case logTypeError = "PWLogTypeError"
        case logTypeWarning = "PWLogTypeWarning"
        case logTypeInfo = "PWLogTypeInfo"
        case logTypeDebug = "PWLogTypeDebug"
    }
    
    var timestamp: String?
    var category: CategoryType?
    var message: String?
    var errorType: ErrorType?
    
    let dictionaryInfo: [String: Any]
    
    init(dictionaryInfo: [String: Any]) {
        self.dictionaryInfo = dictionaryInfo
        
        if let timestamp = dictionaryInfo["timestamp"] as? String {
            self.timestamp = timestamp
        }
        if let details = dictionaryInfo["details"] as? [String: Any], let category = details["category"] as? String {
            self.category = CategoryType(rawValue: category)
        }
        if let message = dictionaryInfo["message"] as? String {
            self.message = message
        }
        if let errorTypeString = dictionaryInfo["type"] as? String {
            self.errorType = ErrorType(rawValue: errorTypeString)
        }
    }
    
    
}
