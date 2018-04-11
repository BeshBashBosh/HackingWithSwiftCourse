//
//  ViewController.swift
//  DetectABeacon
//
//  Created by Ben Hall on 11/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

// NOTE: To request access to a users location. Need to visit the info.plist
//       Need to add item "Privacy - Location Always Usage Description" (location even when app not running)
//                        "Privacy - Location When In Use Usage Description" (loc only when app running)
//                        "Privacy - Location Always and When In Use Usage Description" (noth of above)
//                        Type should be set to string with a value explaining why loc needed.
//        NOTE: If third option used, need to also include the second option with a value

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - Outlets
    @IBOutlet var distanceReading: UILabel! // This will change based on distance to iBeacon
    
    // MARK: - Properties
    var locationManager: CLLocationManager! // will hold an instance to the CoreLocation manager

    // MARK: - Custom methods
    func startScanning() {
        // Create UUID for beacon to discover
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        // Build the remainder of the unique beacon region
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        // Start monitoring for this unique beacon
        locationManager.startMonitoring(for: beaconRegion)
        // Start ranging (measuring distance) for this beacon
        locationManager.startRangingBeacons(in: beaconRegion)
        
    }
    
    // MARK: - CoreLocation Delegate Methods
    // This is called when user makes a decision on authorization request
    // Can handle the change in authorization here
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways { // Check it's always authorized
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) { // can the device monitor iBeacons?
                if CLLocationManager.isRangingAvailable() { // Is ranging of iBeacons possible?
                    // do stuff
                    startScanning()
                }
            }
        } else {
            print("Not always authorized")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Request user authorization for location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization() // or .requestWhenInUseAuthorization() if that add to .plist
        
        // Set view background color to gray
        view.backgroundColor = .gray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

