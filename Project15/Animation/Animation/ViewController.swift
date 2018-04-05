//
//  ViewController.swift
//  Animation
//
//  Created by Ben Hall on 05/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var tap: UIButton!
    
    // MARK: - Actions
    @IBAction func tapped(_ sender: UIButton) {
        // Increment the animation
        currentAnimation += 1
        // Cycle back to animation 0 eventually
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    
    // MARK: - Properties
    var imageView: UIImageView! // The thing we are going to animate
    var currentAnimation = 0 // For cycling through animations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create the imageview in code
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

