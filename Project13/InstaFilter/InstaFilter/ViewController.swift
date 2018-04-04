//
//  ViewController.swift
//  InstaFilter
//
//  Created by Ben Hall on 04/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    
    // MARK: - Actions
    @IBAction func changeFilter(_ sender: UIButton) {
    }
    
    
    @IBAction func save(_ sender: UIButton) {
    }
    
    
    @IBAction func intensityChanged(_ sender: UISlider) {
    }
    
    // MARK: - Load methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

