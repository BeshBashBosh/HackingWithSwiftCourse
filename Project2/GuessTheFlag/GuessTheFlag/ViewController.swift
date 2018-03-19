//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Ben Hall on 19/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    // MARK: - Properties
    var countries = [String]() // array to store list of countries in the game
    var score = 0 // var to keep track of score in game
    
    // MARK: - Actions
    
    // MARK: - Methods
    func askQuestion() {
        // Set the button images to flags. .normal refers to the normal state of the button to be changed
        button1.setImage(UIImage(named: countries[0]) , for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    // MARK: - View Load Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Fill countries array with countries in the game
        countries += ["estonia", "france", "germany", "ireland",
                      "italy", "monaco", "nigeria", "poland", "russia",
                      "spain", "uk", "us"]
        
        // Gampeplay: ask the question
        askQuestion()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

