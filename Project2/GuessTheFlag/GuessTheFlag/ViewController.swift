//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Ben Hall on 19/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import GameplayKit // Mostly for easy RNG/shuffle

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    // MARK: - Properties
    var countries = [String]() // array to store list of countries in the game
    var score = 0 // var to keep track of score in game
    var correctAnswer = 0 // variable for storing which of 3 flags shown is correct answer
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        print(countries[sender.tag])
        // 1. Compare to correctAnswer
        if sender.tag == correctAnswer {
            // 2a. Adjust score: Correct (+1)
            score += 1
            title = "Correct!"
        } else {
            // 2b. Incorrect (-1)
            score -= 1
            title = "Uh-oh, incorrect!"
        }
        
        // 3. Show message telling them new score
        // Use UIAlertController
        // a. instantiate an alert controller
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        // b. add actions to dismiss
        // NOTE: if the handler closure is a function it should be without ().
        // If they were included it would run the function rather than pass it.
        // Also the closure is expected to be able to accept a UIAlertAction
        // This has been added as a default argument (=nil)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        // c. present the AlertController
        present(ac, animated: true)
    }
    
    // MARK: - Methods
    func askQuestion(action: UIAlertAction! = nil) {
        // Shuffle the countries array such the the first three elements shown in below button
        // are 1. random, 2. unique. .arrayByShuflfingObjects(in:) returns [Any] so needs typecasting
        countries = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: countries) as! [String]
        print(countries[0..<3])
        
        // Randomly select which of the flags will be the correct answer
        correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: 3) //upperBound is up to but not including
        
        // Set the correct answer to the title of the navcontroller
        title = countries[correctAnswer].uppercased()
        
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
        
        // Add UX flair to buttons using CALayer attributes
        for btn in [button1, button2, button3] as! [UIButton] {
            // Border around buttons
            btn.layer.borderWidth = 1
            // Border color
            btn.layer.borderColor = UIColor.lightGray.cgColor
            
        }
        
        // Gampeplay: ask the question
        askQuestion()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

