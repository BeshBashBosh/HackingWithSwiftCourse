//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Ben Hall on 22/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    // MARK: - Properties
    var letterButtons = [UIButton]() // This will be connected to buttons in code
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 // The users score
    var level = 1 // The game level the user is on
    
    // MARK: -  Outlets
    @IBOutlet var cluesLabel: UILabel!
    @IBOutlet var answersLabel: UILabel!
    @IBOutlet var currentAnswer: UITextField!
    @IBOutlet var scoreLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func submitTapped(_ sender: UIButton) {
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
    }
    
    @objc func letterTapped(btn: UIButton) {
        
    }
    
    //MARK: - Methods
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        // Get path to level file
        if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") {
            // Get contents of path
            if let levelContents = try? String(contentsOfFile: levelFilePath) {
                // Break up lines of file
                var lines  = levelContents.components(separatedBy: "\n")
                // Shuffle lines (randomized order of questions in level)
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
                
                // Loop through each line and extract the clue, solution, and letterBits
                for (index, line) in lines.enumerated() {
                    // First separate line into answer and clue
                    let parts = line.components(separatedBy: ": ")
                    // Answer is first part, clue is second part
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    // Parse and assign the clue string (e.g. 1. The clue is this.)
                    clueString += "\(index + 1). \(clue)\n"
                    
                    // Parse the solution word into solution and letterBits
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    // Store solution in class property
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        // Configure labels and buttons
    }
    
    // MARK: - VC Load methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Connect up buttons via code and the subview tag
        // that was set to 1001 in the IB
        for sv in view.subviews where sv.tag == 1001 {
            let btn = sv as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped),
                          for: .touchUpInside)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

