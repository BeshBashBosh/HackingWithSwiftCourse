//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Ben Hall on 10/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

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
    
    @objc func scheduleLocal() {
        
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

