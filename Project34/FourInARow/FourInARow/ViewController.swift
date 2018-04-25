//
//  ViewController.swift
//  FourInARow
//
//  Created by Ben Hall on 25/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var columnButtons: [UIButton]!
    
    // MARK: - Actions
    @IBAction func makeMove(_ sender: UIButton) {
    }
    
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

