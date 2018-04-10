//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Ben Hall on 10/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    // MARK: - UN custom methods
    // Give categories of options user can clik in the notif
    func registerCategories() {
        // Get UN instance
        let center = UNUserNotificationCenter.current()
        // Set delegate to this VC
        center.delegate = self
        
        // Create UNNotificationAction
        // Requires inputs of: 1. unique identifier (gets sent when button tapped)
        //                     2. title (this is what user sees in the interface)
        //                     3. options (describes any special options that relate to the action
        //                                 e.g. .authenticationRequired, .destructive, .foreground)
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        
        // Now group (as many as you want) UNNotifActions into a UNNotificationCategory
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        // NOTE: The identifier is what was set in scheduleLocal as the content.categoryIdentifier property
        // NOTE: intentIdentifiers lets you connect notifications to intents if created
        
        // Add to the notif center
        center.setNotificationCategories([category])
    }
    
    // MARK: - Selector Methods
    // This method will request permission to post local notifications
    @objc func registerLocal() {
        // Get an instance of the notificaiton center
        let center = UNUserNotificationCenter.current()
        
        // Request autho
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay")
            } else {
                print("Neh")
            }
        }
        
    }
    
    // Configures all data needed to schedule a notification
    @objc func scheduleLocal() {
        // Set notif categories
        registerCategories()
        
        // Get instance of NC
        let center = UNUserNotificationCenter.current()
        
        // This removes any pending notification requests
        center.removeAllPendingNotificationRequests()
        
        // Configure content (what to show)
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm" // custom actions
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default()
        
        // Configure trigger (when to show)
        // Calendar notif
        // The below is a repeating notification at 10:30am everyday
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // This trigger happens after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Configure request (combination of content + trigger)
        // Notifications can have a unique identifier that allows you to programmatically update or remove notifs.
        // For example, if the notification was a score update, it would be better to update the notif rather than send
        // new ones when the score changes.
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Add request to the center
        center.add(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add navigation bar items
        // Button to register intent to post local notifications
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self,
                                                           action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self,
                                                            action: #selector(scheduleLocal)
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

