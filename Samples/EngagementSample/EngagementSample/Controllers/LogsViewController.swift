//
//  LogsViewController.swift
//  EngagementSample
//
//  Created on 8/9/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWCore
import PWEngagement

class LogsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollButtonBottomConstraint: NSLayoutConstraint!
    
    let scrollButtonBottomDefault: CGFloat = 20
    
    var searchText = ""
    var searchFilter: LogItem.CategoryType?
    
    var logItems = [LogItem]()
    var filteredLogItems = [LogItem]()
    var selectedLogItem: LogItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage()
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshLogs()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.tintColor = UIColor.black
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.barTintColor = UIColor.white
        searchBar.backgroundColor = UIColor.white
        
        if let textfieldOfSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textfieldOfSearchBar.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let logDetailViewController = segue.destination as? LogDetailViewController, let selectedLogItem = selectedLogItem {
            logDetailViewController.logItem = selectedLogItem
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refreshLogs()
    }
    
    @IBAction func emailLogsTapped(_ sender: UIBarButtonItem) {
        PWLogger.emailLogs()
    }
    
    @IBAction func clearLogsTapped(_ sender: UIBarButtonItem) {
        do {
            if let fileLogger = PWFileLogger.withServiceName(PWEngagement.serviceName()), let logsPath = fileLogger.logsDirectory() {
                let files = FileManager.default.enumerator(atPath: logsPath)
                while let file = files?.nextObject() {
                    try FileManager.default.removeItem(at: URL(fileURLWithPath: "\(logsPath)/\(file)"))
                }
                refreshLogs()
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func refreshLogs() {
        logItems.removeAll()
        do {
            let logPath = try PWFileLogger.mergeLogFilesIntoSingleFile(forService: PWEngagement.serviceName())
            let data = try Data(contentsOf: URL(fileURLWithPath: logPath), options: .mappedIfSafe)
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for dictionaryInfo in jsonArray {
                    let logItem = LogItem(dictionaryInfo: dictionaryInfo)
                    logItems.append(logItem)
                }
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
        filterResults()
    }
    
    @IBAction func upArrowTapped(_ sender: UIButton) {
        guard tableView.numberOfRows(inSection: 0) > 0 else {
            return
        }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    @IBAction func downArrowTapped(_ sender: UIButton) {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        guard numberOfRows > 0 else {
            return
        }
        tableView.scrollToRow(at: IndexPath(row: numberOfRows - 1, section: 0), at: .bottom, animated: true)
    }
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Filter Category", message: nil, preferredStyle: .actionSheet)
        var title = ""
        for categoryType in LogItem.CategoryType.allCases {
            title = categoryType.rawValue
            if searchFilter == categoryType {
                title = "✓ " + title
            }
            let action = UIAlertAction(title: title, style: .default) { [weak self] action in
                self?.searchFilter = categoryType
                self?.filterResults()
            }
            actionSheet.addAction(action)
        }
        
        title = "None"
        if searchFilter == nil {
            title = "✓ " + title
        }
        let noneAction = UIAlertAction(title: title, style: .default) { [weak self] action in
            self?.searchFilter = nil
            self?.filterResults()
        }
        actionSheet.addAction(noneAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate

extension LogsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLogItem = filteredLogItems[indexPath.row]
        performSegue(withIdentifier: String(describing: LogDetailViewController.self), sender: nil)
    }
}

// MARK: UITableViewDataSource

extension LogsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLogItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let logsCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LogsCell.self), for: indexPath) as? LogsCell {
            let logItem = filteredLogItems[indexPath.row]
            logsCell.configure(logItem: logItem)
            cell = logsCell
        }
        
        return cell
    }
}

// MARK: UISearchBarDelegate

extension LogsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText.lowercased()
        filterResults()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        filterResults()
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func filterResults() {
        filteredLogItems = logItems
        if let searchFilter = searchFilter {
            filteredLogItems = filteredLogItems.filter {
                if let category = $0.category {
                    return category == searchFilter
                }
                return false
            }
        }
        if searchText.count > 0 {
            filteredLogItems = filteredLogItems.filter {
                if let message = $0.message {
                    return message.lowercased().contains(self.searchText)
                }
                return false
            }
        }
        
        tableView.reloadData()
    }
}

// MARK: UIKeyboard Methods

extension LogsViewController {
    
    @objc func keyboardDidShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let tabBarController = tabBarController {
            let newHeight = keyboardSize.size.height - tabBarController.tabBar.frame.height
            let insets = UIEdgeInsetsMake(0, 0, newHeight, 0)
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
            scrollButtonBottomConstraint.constant = newHeight + scrollButtonBottomDefault
        }
    }
    
    @objc func keyboardWillHide() {
        let insets = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        scrollButtonBottomConstraint.constant = scrollButtonBottomDefault
    }
}
