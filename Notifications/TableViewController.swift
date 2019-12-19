//
//  ViewController.swift
//  Notifications
//
//  Created by wtildestar on 17/12/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let notifications = Notifications()
    
    let notificationsType = [
        "Local Notification",
        "Local Notification with Action",
        "Local Notification with Content",
        "Local Notification with APNs",
        "Local Notification with Firebase",
        "Local Notification with Content"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: -  Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsType.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = notificationsType[indexPath.row]
        cell.textLabel?.textColor = .black
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .gray
        
        let notificationType = notificationsType[indexPath.row]
        
        let alert = UIAlertController(title: notificationType, message: "After 5 seconds" + notificationType, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.notifications.scheduleNotification(notificationType: notificationType)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .black
    }
}

