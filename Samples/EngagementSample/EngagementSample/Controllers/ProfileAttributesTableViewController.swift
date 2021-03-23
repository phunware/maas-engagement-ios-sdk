//
//  ProfileAttributesTableViewController.swift
//  EngagementSample
//
//  Created on 8/24/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit
import PWEngagement

enum AttributeKey: String {
    case name = "name"
    case allowedValues = "allowedValues"
}

class ProfileAttributesTableViewController: UITableViewController {
    
    let attributeCellIdentifier = "AttributeCell"
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var discardButton: UIBarButtonItem!
    
    var attributeMetadata = [[String: Any]]()
    var deviceAttributes = [String: String]()
    
    var selectedAttributeMetadata: [String: Any]?
    var hasPendingChanges = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateButtonState()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateButtonState()
        
        refreshControl?.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hasPendingChanges {
            tableView.reloadData()
        }
    }
    
    @objc func refreshControlPulled() {
        refresh()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        displayLoadingAlert(message: "Saving Attributes...")
        PWMEAttributeManager.shared().updateProfileAttributes(deviceAttributes) { [weak self] (error) in
            self?.dismiss(animated: true, completion: nil)
            if let error = error {
                self?.displayErrorAlert(message: error.localizedDescription)
            } else {
                self?.hasPendingChanges = false
            }
        }
    }
    
    @IBAction func discardButtonTapped(_ sender: UIBarButtonItem) {
        refreshAttributes()
    }
    
    func refresh() {
        if hasPendingChanges {
            tableView.reloadData()
            refreshControl?.endRefreshing()
        } else {
            refreshAttributes()
        }
    }

    func refreshAttributes() {
        displayLoadingAlert(message: "Updating Attributes...")
        PWMEAttributeManager.shared().fetchProfileAttributeMetadata { [weak self] (attributeMetadata, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.dismiss(animated: true, completion: nil)
                    self?.displayErrorAlert(message: error.localizedDescription)
                    self?.refreshControl?.endRefreshing()
                } else {
                    if let attributeMetadata = attributeMetadata as? [[String: Any]] {
                        self?.attributeMetadata = attributeMetadata.sorted(by: { ($0[AttributeKey.name.rawValue] as! String).lowercased() < ($1[AttributeKey.name.rawValue] as! String).lowercased() })
                    }
                    PWMEAttributeManager.shared().fetchProfileAttributes(completion: { [weak self] (deviceAttributes, error) in
                        if let error = error {
                            self?.dismiss(animated: true, completion: nil)
                            self?.displayErrorAlert(message: error.localizedDescription)
                        } else {
                            if let deviceAttributes = deviceAttributes as? [String: String] {
                                self?.deviceAttributes = deviceAttributes
                            }
                            self?.tableView.reloadData()
                            self?.dismiss(animated: true, completion: nil)
                            self?.hasPendingChanges = false
                        }
                        self?.refreshControl?.endRefreshing()
                    })
                }
            }
        }
    }
    
    func updateButtonState() {
        saveButton.isEnabled = hasPendingChanges
        discardButton.isEnabled = hasPendingChanges
    }
    
    func displayLoadingAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        
        alertController.view.addSubview(loadingIndicator)
        present(alertController, animated: true, completion: nil)
    }
    
    func displayErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let attributeTableViewController = segue.destination as? AttributeTableViewController {
            attributeTableViewController.attributeMetadata = selectedAttributeMetadata
            attributeTableViewController.deviceAttributes = deviceAttributes
            attributeTableViewController.delegate = self
        }
    }
}

// MARK: - UITableView

extension ProfileAttributesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributeMetadata.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: attributeCellIdentifier, for: indexPath)
        
        let attribute = attributeMetadata[indexPath.row]
        if let attributeName = attribute[AttributeKey.name.rawValue] as? String {
            cell.textLabel?.text = attributeName
            if let attributeValue = deviceAttributes[attributeName] {
                cell.detailTextLabel?.text = attributeValue
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedAttributeMetadata = attributeMetadata[indexPath.row]
        return indexPath
    }
}

// MARK: - DeviceAttributesUpdatable

extension ProfileAttributesTableViewController: DeviceAttributesUpdateDelegate {
    
    func deviceAttributesUpdated(_ deviceAttributes: [String: String]) {
        if deviceAttributes != self.deviceAttributes {
            self.deviceAttributes = deviceAttributes
            hasPendingChanges = true
        }
    }
}
