//
//  LocationsViewController.swift
//  EngagementSample
//
//  Created on 8/9/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit
import PWEngagement

enum LocationFilter: Int {
    case all = 0
    case inside
    case monitored
}

class LocationsViewController: UIViewController {

    let locationCellIdentifier = "LocationTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentLocationFilter = LocationFilter.all {
        didSet {
            refreshDisplayedLocations()
        }
    }
    var locations: [PWMEGeozone]? {
        didSet {
            refreshDisplayedLocations()
        }
    }
    var displayedLocations: [PWMEGeozone]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage()
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
        let notificationNames = [PWMEAddGeoZonesNotificationKey, PWMEModifyGeoZonesNotificationKey, PWMEDeleteGeoZonesNotificationKey, PWMEEnterGeoZoneNotificationKey, PWMEExitGeoZoneNotificationKey, PWMEMonitoredGeoZoneChangesNotificationKey]
        for notificationName in notificationNames {
            NotificationCenter.default.addObserver(self, selector: #selector(refreshLocations), name: NSNotification.Name(rawValue: notificationName), object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshLocations()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func filterSegmentedControlChanged(_ sender: UISegmentedControl) {
        currentLocationFilter = LocationFilter(rawValue: sender.selectedSegmentIndex)!
    }
    
    @objc func refreshLocations() {
        DispatchQueue.main.async {
            self.locations = PWEngagement.geozones()?.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        }
    }
    
    func refreshDisplayedLocations() {
        switch currentLocationFilter {
        case .all:
            displayedLocations = locations
        case .inside:
            displayedLocations = locations?.filter({ $0.inside })
        case .monitored:
            displayedLocations = locations?.filter({ $0.monitored })
        }
    }
}

// MARK: - UITableView

extension LocationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: locationCellIdentifier), let location = displayedLocations?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.textLabel?.text = location.name
        cell.backgroundColor = .white
        
        if location.monitored {
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
            if location.inside {
                cell.backgroundColor = UIColor(red: 215/255, green: 243/255, blue: 237/255, alpha: 1)
                cell.detailTextLabel?.text = "Inside"
                cell.detailTextLabel?.textColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 51.0/255.0, alpha: 1.0)
            } else {
                cell.detailTextLabel?.text = "Outside"
                cell.detailTextLabel?.textColor = .blue
            }
        } else {
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 11.0)
            cell.detailTextLabel?.text = "Not Monitored"
            cell.detailTextLabel?.textColor = .red
        }
        
        return cell
    }
}
