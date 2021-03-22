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

                PWEngagement.fetchMessages(startDate: Date(timeIntervalSinceNow: -MessageCenter.fetchPeriodInSeconds), endDate: Date()) { (messages, error) in
                    DispatchQueue.main.async {
                        if let err = error {
                            print(err.localizedDescription)
                            navController.tabBarItem.badgeValue = nil
                            return
                        }
                        guard let messages = messages else {
                            navController.tabBarItem.badgeValue = nil
                            return
                        }
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
}
