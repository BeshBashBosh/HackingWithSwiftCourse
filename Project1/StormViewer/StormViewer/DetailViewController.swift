//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Ben Hall on 19/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // Create an outlet to the IB UIImageView
    @IBOutlet var imageView: UIImageView!
    
    
    // Create a variable to store the path of the selected image to be loaded
    var selectedImage: String? // Optional as it won't exist when the VC is first created
    
    // MARK: iPhone X compatibility to hide home bar indicator after a few secs of inactivity
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        // This code below will allow the home bar and navbar to come and go in unison
        return navigationController!.hidesBarsOnTap
    }
    
    // MARK: view*Load/Appear() methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
        // Set title for nav controller
        title = selectedImage
        
        // Disable large titles (Apple recommedation is only for first screen!)
        navigationItem.largeTitleDisplayMode = .never
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Hide NavBar on Tap
    // Setting behaviour of hiding navigation bar on tap for this VC only
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
