//
//  TabBarController.swift
//  EngagementSample
//
//  Created on 8/10/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit
import PWEngagement

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateMessages(_:)), name: NSNotification.Name(rawValue: PWMEReceiveMessageNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMessages(_:)), name: NSNotification.Name(rawValue: PWMEReadMessageNotificationKey), object: nil)
        
        badgeMessagesTabBarItem()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateMessages(_ notification: NSNotification) {
        badgeMessagesTabBarItem()
    }
    
    func badgeMessagesTabBarItem() {
        guard let viewControllers = viewControllers else {
            return
        }
        
        for viewController in viewControllers {
            if let navController = viewController as? UINavigationController, navController.viewControllers.first is MessagesViewController {
                if let messages = PWEngagement.messages() {
                    let unreadMessages = messages.filter({ $0.isRead == false }).count
                    if unreadMessages > 0 {
                        navController.tabBarItem.badgeValue = "\(unreadMessages)"
                    } else {
                        navController.tabBarItem.badgeValue = nil
                    }
                }
            }
        }
    }
}
