//
//  AttributeTableViewController.swift
//  EngagementSample
//
//  Created on 8/24/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit

protocol DeviceAttributesUpdateDelegate {
    func deviceAttributesUpdated(_ deviceAttributes: [String: String])
}

class AttributeTableViewController: UITableViewController {

    let attributeValueCellIdentifier = "AttributeValueCell"
    
    var delegate: DeviceAttributesUpdateDelegate?
    var attributeMetadata: [String: Any]!
    var deviceAttributes: [String: String]!
    var attributeValues = [String]()
    var attributeName: String {
        return attributeMetadata[AttributeKey.name.rawValue] as! String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = attributeName
        
        attributeValues = attributeMetadata[AttributeKey.allowedValues.rawValue] as! [String]
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributeValues.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: attributeValueCellIdentifier, for: indexPath)

        let deviceAttributeValue = deviceAttributes[attributeName]
        if indexPath.row == 0 {
            cell.textLabel?.text = "No Value"
            cell.textLabel?.font = .italicSystemFont(ofSize: 17.0)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .lightGray
            if deviceAttributeValue == nil {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            let attributeValue = attributeValues[indexPath.row - 1]
            cell.textLabel?.text = attributeValue
            cell.textLabel?.font = .systemFont(ofSize: 17.0)
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
            if attributeValue == deviceAttributeValue {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            deviceAttributes.removeValue(forKey: attributeName)
        } else {
            let attributeValue = attributeValues[indexPath.row - 1]
            deviceAttributes[attributeName] = attributeValue
        }
        delegate?.deviceAttributesUpdated(deviceAttributes)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}
