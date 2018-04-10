//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Ben Hall on 10/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Selector Methods
    @objc func registerLocal() {
        
    }
    
    @objc func scheduleLocal() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add navigation bar items
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

