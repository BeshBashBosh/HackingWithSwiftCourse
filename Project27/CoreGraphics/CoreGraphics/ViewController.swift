//
//  ViewController.swift
//  CoreGraphics
//
//  Created by Ben Hall on 12/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    var currentDrawType = 0 // This will be used to cycle through CoreGraphics
    
    // MARK: - Custom methods
    func drawRectangle() {
        
    }
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Actions
    @IBAction func redrawTapped(_ sender: UIButton) {
        // Increment the drawing type
        currentDrawType += 1
        
        // Recycle draw type after 5 iterations
        if currentDrawType > 5 { currentDrawType = 0 }
        
        // Switch on draw type to see how to draw
        switch currentDrawType {
        case 0:
            drawRectangle()
        default:
            break
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        drawRectangle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

