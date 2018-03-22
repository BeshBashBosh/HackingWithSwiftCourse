//
//  ViewController.swift
//  AutoLayout
//
//  Created by Ben Hall on 22/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Make some custom views
        let label1  = UILabel()
        // Prohibit iOS from automatically deciding what the auto-layout constraints should be.
        // Will be doing these manually.
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.red
        label2.text = "ARE"

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"

        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"

        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"

        // Add views to main view
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        // Add constraints using Auto Layout's Visual Formatting Language (VFL)
        
        // The Auto Layout VFL which has following syntax:
        // First: Are we addressing Horizontal (H) or Vertical (V) layout
        // Second: Pipes (|) represent the edge of the superview
        // Third: The edge of the subview is represented by []
        // Also: A '-' represents a space (10pts default)
        //
        // An example:
        //     H:|[label1]| <- Horizontally space the UILabel from edge-edge of the superview
        //     V:|[label1]-[label2]-[label3]-[label4]-[label5] <- Space UILabels from top edge of superview.
        //                                                        No final pipe tells the VFL that it's not necessary
        //                                                        to take subviews to bottom edge of superview.
        //
        // This size of a subview or constrain is described with (for example):
        //     V:[label1(==88)]-(>=10)-| <- label has vertical height of 88pts,
        //                                  buttom constraint is >= 10pts between final subview and pipe
        //
        // However, putting literal values in this is a recipe for disaster if it changes.
        // This is where the 'metrics' argument of VFL comes in, e.g.
        //      let metrics = ["labelHeight": 88]
        // and swap out any of the (==88) with labelHeight
        //
        // If we want other labels to match the metrics set for another, we can put that labels name in as
        // the metrics part of the VFL string e.g.
        //      V:|[label1(labelHeight)]-[label2(label1)]-[label3(label1)]
        // If we want to lower the priority of a constraint, use @(some_number_lt_1000), where 1000 is the highest
        // priority
        
        
        // 1. Make a dictionary of views to be constrained
        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3,
                               "label4": label4, "label5": label5]
        // 2. Loop through this dictionary adding constraints to each subview
        for label in viewsDictionary.keys {

            // Horizontal layout
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [],
                                                              metrics: nil, views: viewsDictionary))
        }
        let metrics = ["labelHeight": 88]
        // Vertical layout
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
        
        

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

