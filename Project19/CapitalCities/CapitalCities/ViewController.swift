//
//  ViewController.swift
//  CapitalCities
//
//  Created by Ben Hall on 09/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
// TODO: - Add UIAlertController action sheet so user can specify how map is viewd (mapType -> .satellite etc.)
// TODO: - Typecast dequeueReusableAnnotationView() return value as MKPinAnnotationView.
//         Allows changing of pinTintColor. Then add favourite button to pins that changes
//         pin to red (regular) or green (favourite)
// TODO: - Store TODO2 in UserDefaults
// TODO: - Let user dynamically add new pins (e.g. cities they want to visit?)


import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - MapView Delegate Methods
    // Every time map needs to show an annotation, this method is called
    // Like Table/CollectionViews, MapView reuses annotations views to make best use of memory
    // BUT, if none available to use, have to create one using MKPinAnnotationView class.
    // NOTE: viewFor method is called for custom annotations, and Apple's. If Apple's not wanted return nil from viewFor.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1. Define reuse identifier for annotation
        let identifier = "Capital"
        // 2. Check whether annotation being created is custom of one of Apple's.
        if annotation is Capital {
            // 3a. Try to dequeue an annotation view from MapView's pool of unused vies
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            // 3b. else create a new one using MKPinAnnotationView and set canShowCallout property to true
            // (triggers popup of city name)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true // Boolean to say annotation can show more info in callout bubble
                // 4. Create UIButton (.detailDisclosure type, small blue 'i' with circle around it)
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                // 5. If reuse view, update view to use different annotation
                annotationView!.annotation = annotation
            }
            // Return this annotationView
            return annotationView
        }
        
        // 6. If not a Capital annotation, return nil so iOS can use default view
        return nil
    }
    
    // Presenting the annotation info when disclosure tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let capital = view.annotation as! Capital
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
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

