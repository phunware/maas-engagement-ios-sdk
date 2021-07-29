//
//  InfoViewController.swift
//  EngagementSample
//
//  Created on 8/9/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import UserNotifications
import UIKit
import CoreLocation

import PWEngagement

class InfoTableViewController: UITableViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var appIdLabel: UILabel!
    @IBOutlet weak var monitorRegionRadiusLabel: UILabel!
    @IBOutlet weak var buildVersionLabel: UILabel!
    @IBOutlet weak var coreVersionLabel: UILabel!
    @IBOutlet weak var deviceIdLabel: UILabel!
    @IBOutlet weak var iosVersionLabel: UILabel!
    @IBOutlet weak var zonesLabel: UILabel!
    @IBOutlet weak var monitoredZonesLabel: UILabel!
    @IBOutlet weak var insideZonesLabel: UILabel!
    @IBOutlet weak var messagesLabel: UILabel!
    
    let clLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationNames = [PWMEAddGeoZonesNotificationKey, PWMEModifyGeoZonesNotificationKey, PWMEDeleteGeoZonesNotificationKey, PWMEEnterGeoZoneNotificationKey, PWMEExitGeoZoneNotificationKey, PWMEMonitoredGeoZoneChangesNotificationKey, PWMELocationServiceReadyNotificationKey]
        for notificationName in notificationNames {
            NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: notificationName), object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clLocationManager.requestAlwaysAuthorization()
        updateUI()
    }
    
    @objc func updateUI() {
        DispatchQueue.main.async {
            let notYetRegisteredText = "Not yet registered"
            let engagementModuleVersion = PWCore.getVersionForModule(PWEngagement.serviceName())
            self.versionLabel.text = (engagementModuleVersion?.count ?? 0) > 0 ? engagementModuleVersion : notYetRegisteredText
            self.appIdLabel.text = PWCore.applicationID()
            self.serverLabel.text = self.environmentString(PWCore.getEnvironment())
            let coreModuleVersion = PWCore.getVersionForModule(PWCore.serviceName())
            self.coreVersionLabel.text = (coreModuleVersion?.count ?? 0) > 0 ? coreModuleVersion : notYetRegisteredText
            self.deviceIdLabel.text = PWEngagement.deviceId()
            self.iosVersionLabel.text = UIDevice.current.systemVersion
            self.monitorRegionRadiusLabel.text = "50,000"

            PWEngagement.fetchMessages(startDate: Date(timeIntervalSinceNow: -MessageCenter.fetchPeriodInSeconds), endDate: Date()) { [weak self] (messages, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.messagesLabel.text = "0"
                        print(error.localizedDescription)
                        return
                    }
                    guard let messages = messages else {
                        self?.messagesLabel.text = "0"
                        return
                    }
                    self?.messagesLabel.text = "\(messages.count)"
                }
            }

            self.buildVersionLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            if let geozones = PWEngagement.geozones() {
                self.zonesLabel.text = "\(geozones.count)"
                let monitoredZones = geozones.filter({ $0.monitored })
                self.monitoredZonesLabel.text = "\(monitoredZones.count)"
                let insideZones = geozones.filter({ $0.inside })
                self.insideZonesLabel.text = "\(insideZones.count)"
            } else {
                self.zonesLabel.text = "0"
                self.monitoredZonesLabel.text = "0"
                self.insideZonesLabel.text = "0"
            }
        }
    }
    
    func environmentString(_ environment: PWEnvironment) -> String {
        let environmentString: String
        switch environment {
        case .dev:
            environmentString = "Dev"
        case .stage:
            environmentString = "Stage"
        case .prod:
            environmentString = "Prod"
        }
        return environmentString
    }
}
