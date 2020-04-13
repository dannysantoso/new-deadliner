//
//  NotificationViewController.swift
//  DeadlinerNotificationExtension
//
//  Created by Peter Andrew on 12/04/20.
//  Copyright © 2020 Peter Andrew. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelEndDate: UILabel!
    @IBOutlet weak var labelPriority: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        self.label?.text = userInfo["title"] as? String
        labelStartDate.text = userInfo["startDate"] as? String
        labelEndDate.text = userInfo["endDate"] as? String
        let activityPriority = userInfo["priority"] as! Int
        setPriorityLabel(labelPriority,activityPriority)
        
    }
    
    private func setPriorityLabel(_ label:UILabel,_ priority:Int){
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        
        switch priority {
            case 3:
                label.text = "High"
                label.backgroundColor = .red
            case 2:
                label.text = "Medium"
                label.backgroundColor = .orange
                
            case 1:
                label.text = "Low"
                label.backgroundColor = .blue
                
            default:
                label.text = "High"
                label.backgroundColor = .red
        }
    }

}
