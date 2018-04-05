//
//  ViewController.swift
//  Animation
//
//  Created by Ben Hall on 05/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    var imageView: UIImageView! // The thing we are going to animate
    var currentAnimation = 0 // For cycling through animations
    
    // MARK: - Outlets
    @IBOutlet var tap: UIButton!
    
    // MARK: - Actions
    @IBAction func tapped(_ sender: UIButton) {
        
        // Animate ui view
        // Hide button whilst animation happens so user doesn't attempt multiple animations
        tap.isHidden = true
        
        // Let animation of UIView have a duration of 1sec starting immediately/
        UIView.animate(withDuration: 1, delay: 0, options: [],
                       animations: { [unowned self] in
                        // Switch on the animation number to decide which animation to run
                        switch self.currentAnimation {
                        case 0:
                            break
                            
                        default:
                            break
                        }
        }) { [unowned self] (finished: Bool) in
            // Animation finished so let's show the tap button again ready for the next animation
            self.tap.isHidden = false
        }
        
        // Increment the animation counter
        currentAnimation += 1
        
        // Cycle back to animation 0 eventually
        if currentAnimation > 7 {
            currentAnimation = 0
        }
        
    }
    
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

