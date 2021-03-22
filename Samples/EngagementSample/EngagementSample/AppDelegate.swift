//
//  AppDelegate.swift
//  EngagementSample
//
//  Created on 8/9/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit

import PWCore
import UserNotifications
import PWEngagement

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    let applicationId = ""
    let accessKey = ""
    let signatureKey = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        PWLogger.fileLoggingEnabled(true, forService: PWEngagement.serviceName())
        PWLogger.setLoggersLogLevel(.debug)
        
        PWEngagement.start(withMaasAppId: applicationId, accessKey: accessKey, signatureKey: signatureKey) { (error) in
            if let error = error {
                print("Error starting Engagement: \(error.localizedDescription)")
            }
        }
        UIApplication.shared.unregisterForRemoteNotifications()
        UIApplication.shared.registerForRemoteNotifications()
        
        // Request authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else {
                return
            }
            
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus != .authorized {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        }
        UNUserNotificationCenter.current().delegate = self
        
        PWEngagement.didFinishLaunching(options: launchOptions) { (_) -> Bool in return true }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PWEngagement.didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PWEngagement.didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PWEngagement.didReceiveNotification(userInfo) { (_, _) in
            completionHandler(.newData)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        PWEngagement.didReceiveNotification(notification.request.content.userInfo) { [weak self] (message, error) in
            if let message = message {
                let alertVC = UIAlertController(title: message.alertTitle, message: message.alertBody, preferredStyle: .alert)
                let viewAction = UIAlertAction(title: NSLocalizedString("View", comment: ""), style: .default) { (_) in
                    self?.deeplink(message: message)
                }
                alertVC.addAction(viewAction)
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (_) in }
                alertVC.addAction(cancelAction)
                
                self?.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
                
                completionHandler(.init(rawValue: 0))
            } else {
                completionHandler(.alert)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        PWEngagement.didReceiveNotification(response.notification.request.content.userInfo) { [weak self] (message, error) in
            if let message = message {
                self?.deeplink(message: message)
            }
            
            completionHandler()
        }
    }
}

extension AppDelegate {
    
    func deeplink(message: Message) {
        
        if let tabbarController = window?.rootViewController as? UITabBarController {
            tabbarController.selectedIndex = 2
            if let selectedNavController = tabbarController.selectedViewController as? UINavigationController, let messagesViewController = selectedNavController.viewControllers.first as? MessagesViewController {
                messagesViewController.selectedMessage = message
                messagesViewController.performSegue(withIdentifier: String(describing: MessageDetailViewController.self), sender: nil)
            }
        }
    }
}
