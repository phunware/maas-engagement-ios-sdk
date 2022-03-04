//
//  DispatchQueue+Threading.swift
//  EngagementSample
//
//  Created by Tyler Prevost on 6/10/21.
//  Copyright © 2021 Phunware. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static func executeOnMain(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            main.sync(execute: work)
        }
    }
}
