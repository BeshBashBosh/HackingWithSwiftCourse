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
    
    // The users score - prop observer to increment score label
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1 // The game level the user is on
    
    // MARK: -  Outlets
    @IBOutlet var cluesLabel: UILabel!
    @IBOutlet var answersLabel: UILabel!
    @IBOutlet var currentAnswer: UITextField!
    @IBOutlet var scoreLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func submitTapped(_ sender: UIButton) {
        // Find if solution exists as one of the answers
        if let solutionPosition = solutions.index(of: currentAnswer.text!) {
            // Have found the position of the submitted answer in solutions
            
            // Remove activated buttons
            activatedButtons.removeAll()
            
            // Split the current answers label (e.g. X letters\nY letters\n) into parts by newline character
            var splitAnswers = answersLabel.text!.components(separatedBy: "\n")
            // At the index of the correct clue, change text to submitted answer
            splitAnswers[solutionPosition] = currentAnswer.text!
            // Rejoing the array into a string with newline characters after each answer
            answersLabel.text = splitAnswers.joined(separator: "\n")
            
            // Reset the current answer field
            currentAnswer.text = ""
            // Increment the score
            score += 1
            
            
            // If the score has divisible by 7 alert user that all solutions
            // have been found!
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!",
                                           message: "Are you ready for the next level?",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default,
                                           handler: levelUp))
                present(ac, animated: true)
            }
            
        }
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        // Clear the current answer textfield
        currentAnswer.text = ""
        
        // Re-activate used buttons
        for btn in activatedButtons {
            btn.isHidden = false
        }
        // Prep storage (clear it) of active buttons for next game attempt
        activatedButtons.removeAll()
    }
    
    // Deal with letter bits button presses
    @objc func letterTapped(btn: UIButton) {
        // Add button bit text to current answer textfield
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        // Remove that button from play
        activatedButtons.append(btn) // This array we be used to re-enable disabled button on clear button click
        btn.isHidden = true
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
                    print(solutions)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        // Configure labels and buttons
        // Set the text of the clue label to that of the clues]
        // the trimmingCharacters part is removing white space and newlines
        // from start and end of string
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        // And the same for the answers label
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Shuffle up the letter segments
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: letterBits) as! [String]
        
        // If we have same number of letter bits as buttons...
        if letterBits.count == letterButtons.count {
            // Loop through the bits and assign the text to each button
            for i in 0 ..< letterBits.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        // Increment level
        level += 1
        // Reset the solutions array
        solutions.removeAll(keepingCapacity: true)
        
        // Load the next level
        loadLevel()
        
        // Re-enable all buttons
        for btn in letterButtons {
            btn.isHidden = false
        }
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
        
        // load the level
        loadLevel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

