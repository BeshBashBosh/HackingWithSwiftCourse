//
//  ViewController.swift
//  CapitalCities
//
//  Created by Ben Hall on 09/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create some cities
        let london = Capital(title: "London",
                             coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
                             info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo",
                           coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
                           info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris",
                            coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508),
                            info: "Often called the City of Light.")
        let rome = Capital(title: "Rome",
                           coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
                           info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC",
                                 coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667),
                                 info: "Named after George himself.")
        
        // Add annotations to the MapView
        mapView.addAnnotations([london, rome, oslo, paris, rome, washington])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

