//
//  MessagesViewController.swift
//  EngagementSample
//
//  Created on 8/9/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWEngagement

class MessagesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    enum SegmentedControlIndex: Int {
        case all
        case unread
        case read
    }
    
    let segmentedControlIndexes = [SegmentedControlIndex.all, .unread, .read]
    var selectedSegmentedControlIndex = SegmentedControlIndex.all {
        didSet {
            refreshDisplayMessages()
        }
    }
    
    var allMessages: [Message]? {
        didSet {
            refreshDisplayMessages()
        }
    }
    
    private var messages: [Message]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedMessage: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage()
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateMessages(nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? MessageDetailViewController, let selectedMessage = selectedMessage {
            detailViewController.message = selectedMessage
        }
    }
    
    func refreshDisplayMessages() {
        switch selectedSegmentedControlIndex {
        case .unread:
            messages = allMessages?.filter({ $0.isRead == false })
        case .read:
            messages = allMessages?.filter({ $0.isRead == true })
        default:
            messages = allMessages
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        selectedSegmentedControlIndex = segmentedControlIndexes[segmentedControl.selectedSegmentIndex]
    }

    @objc func updateMessages(_ notification: NSNotification?) {
        PWEngagement.fetchMessages(startDate: Date(timeIntervalSinceNow: -MessageCenter.fetchPeriodInSeconds), endDate: Date()) { [weak self] (messages, error) in
            DispatchQueue.main.async {
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                guard let messages = messages else {
                    return
                }
                self?.allMessages = messages
                self?.tableView.reloadData()
            }
        }
    }
}

extension MessagesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let messages = messages else {
            return
        }
        selectedMessage = messages[indexPath.row]
        performSegue(withIdentifier: String(describing: MessageDetailViewController.self), sender: nil)
    }
}

extension MessagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath)
        if let message = messages?[indexPath.row] {
            cell.textLabel?.font = (message.isRead ? UIFont.systemFont(ofSize: UIFont.systemFontSize) : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize))
            cell.textLabel?.text = message.alertTitle
            if let identifier = message.identifier, let timestamp = message.formattedTimestamp() {
                cell.detailTextLabel?.text = "ID: \(identifier), Received at \(timestamp)"
            }
        }
        return cell
    }
}


