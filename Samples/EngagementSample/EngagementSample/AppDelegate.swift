//
//  AppDelegate.swift
//  EngagementSample
//
//  Created on 8/9/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit

import UserNotifications
import PWCore
import PWEngagement

/*
 The "DeviceIdentity" module is a subspec from the Core SDK.
 It only resolves (and is needed) when using SDK binaries.
 */
#if canImport(DeviceIdentity)
    import DeviceIdentity
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Enter your application identifier and access key, found on Maas portal under Account > Apps
    private let applicationId = ""
    private let accessKey = ""
    private var isApplicationFinishedLaunching = false
    private let locationManager = CLLocationManager()
    private var locationAuthorizationStatusCompletion: (() -> Void)?
    private var lastDeviceToken: Data?
    private var launchOptions:  [UIApplication.LaunchOptionsKey: Any]?
    private var hasAppBecomeActiveThisSession = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        self.launchOptions = launchOptions
                        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // With iOS 15.0+, Apple requires that App Tracking Authorization request to be made while app is in active state.
        // So we move all our engagment startup code here.
        guard !self.hasAppBecomeActiveThisSession else {
            return
        }
        self.hasAppBecomeActiveThisSession = true
        
        requestAppTrackingPermission { [weak self] in
            guard let self = self else {
                return
            }
            
            self.requestLocationPermisson { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.requestNotificationsPermission { [weak self] (isAuthorized) in
                    guard let self = self else {
                        return
                    }
                                        
                    // Ensure previously cached analytics are sent to the correct MaaS sever environment
                    PWLogger.fileLoggingEnabled(true, forService: PWEngagement.serviceName())
                    PWLogger.setLoggersLogLevel(.debug)
                    PWEngagement.setLocalNotificationHandler {notification in
                        let hideNotificationIdentifier = "HIDE_NOTIFICATION"
                        return !(notification.message.alertTitle ?? "").contains(hideNotificationIdentifier)
                    }
                    PWEngagement.didFinishLaunching(options: self.launchOptions) { [weak self] (_) -> Bool in
                        DispatchQueue.executeOnMain {
                            guard let self = self else {
                                return
                            }
                            
                            guard !self.isApplicationFinishedLaunching else {
                                return
                            }
                            
                            PWEngagement.start(withMaasAppId: self.applicationId, accessKey: self.accessKey) { (error) in
                                if let error = error {
                                    print("Error starting Engagement: \(error.localizedDescription)")
                                }
                            }

                            self.isApplicationFinishedLaunching = true
                        }
                        
                        return true
                    }
                }
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PWEngagement.didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PWEngagement.didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PWEngagement.didReceiveRemoteNotification(userInfo) { (_, _) in
            completionHandler(.newData)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        PWEngagement.willPresent(notification) { [weak self] (message, _) in
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
        PWEngagement.didReceive(response) { [weak self] (message, _) in
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

// MARK: - App Launch
private extension AppDelegate {
        
    func requestLocationPermisson(completion: @escaping () -> Void) {
        // Supposedly, we shouldn't need to check authorization status before calling request authorization,
        // But the didChangeAuthorization delegate doesn't always get called after user have selected
        // a permission option.
        if authorizationStatus(locationManager) == .notDetermined {
            locationAuthorizationStatusCompletion = completion
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
        } else {
            DispatchQueue.executeOnMain(completion)
        }
    }
    
    func requestAppTrackingPermission(completion: @escaping () -> Void) {
        let mainThreadCompletion = {
            DispatchQueue.executeOnMain(completion)
        }
        
        guard #available(iOS 14.0, *) else {
            mainThreadCompletion()
            return
        }
        
        switch PWCore.isAdvertisingIdentifierPermissionRequestable {
        case .allowed:
            PWCore.requestAdvertisingIdentifierPermission { _ in
                // We got permission to track
                mainThreadCompletion()
            } failure: { error in
                // Permission was denied
                print("Error requesting advertising identifier permission:", error)
                mainThreadCompletion()
            }
        case .notAllowed,
             .alreadyAuthorized:
            fallthrough
        @unknown default:
            mainThreadCompletion()
        }
    }
    
    func requestNotificationsPermission(completion: @escaping (_ isAuthorized: Bool) -> Void) {
        let mainThreadCompletion: (_ isAuthorized: Bool) -> () = { isAuthorized in
            DispatchQueue.executeOnMain {
                completion(isAuthorized)
            }
        }
        let userNotificationCenter = UNUserNotificationCenter.current()
        
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("An unexpected error occurred while requesting authorization for notifications: \(String(describing: error?.localizedDescription))")
                mainThreadCompletion(false)
                return
            }
            
            mainThreadCompletion(granted)
        }
    }
}

extension AppDelegate : CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager === locationManager else {
            fatalError("AppDelegate does not support being the delegate of CLLocationManager objects other than its own private location manager.")
        }
        
        guard authorizationStatus(manager) != .notDetermined else {
            return
        }
        
        guard let locationAuthorizationStatusCompletion = locationAuthorizationStatusCompletion else {
            fatalError("AppDelegate.locationAuthorizationStatusCompletion must be set before location authorization changes")
        }
        
        DispatchQueue.executeOnMain(locationAuthorizationStatusCompletion)
        
        manager.delegate = nil
        self.locationAuthorizationStatusCompletion = nil
    }
    
    // Provide support for iOS 13.x and less
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManagerDidChangeAuthorization(manager)
    }
    
    private func authorizationStatus(_ manager: CLLocationManager) -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return manager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
}
