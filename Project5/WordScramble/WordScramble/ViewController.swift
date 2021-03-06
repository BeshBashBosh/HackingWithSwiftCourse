//
//  ViewController.swift
//  WordScramble
//
//  Created by Ben Hall on 21/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {

    // MARK: - Properties
    var allWords = [String]() // Will store all words that can be played
    var usedWords = [String]() // Will store the words that have been played
    var gameState = 0 {
        willSet {
            print("Changing from \(gameState) to \(newValue)")
        }
        didSet {
            if oldValue == allWords.count - 1 {
                print("Resetting game state")
                gameState = 0
            }
            print("Changed from \(oldValue) to \(gameState)")
        }
    }

    
    // MARK: - tableView Methods
    // Set the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    // Set what to do with protocell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    // MARK: - Methods
    
    // Starting the game
    func startGame() {
        // Randomise the word list if initial start of game
        if gameState == 0 || gameState == allWords.count {
            allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        }
        
        title = allWords[gameState]
        
        // Increment the gamestate
        gameState += 1
        
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    // Handling the answer submitted by the user
    func submit(answer: String) {
        // For easier parsing convert answer to all lower case
        let lowerAnswer = answer.lowercased()
        
        // Logic tests to see if user answer is an anagram
        // 1. Does input contain same set of letters as question word?
        if isPossible(word: lowerAnswer) {
            // 2. Is this an original word compared to previous inputs
            if isOriginal(word: lowerAnswer) {
                // 3. Is the input a real word?
                if isReal(word: lowerAnswer) {
                    // Passed all logic so add to usedWords array
                    usedWords.insert(answer, at: 0)
                    // Update the tableView by inserting this new answer (no need to reload the entire table)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    showErrorMessage(title: "Word not recognised or too short",
                                     message: "You can't just make up words, you know! Also they should have more than three letters")
                }
            } else {
                showErrorMessage(title: "Word used already",
                                 message: "Be more original!")
            }
        } else {
            showErrorMessage(title: "Word not possible",
                             message: "You can't spell that word from the letters in \(title!.lowercased())!")
        }
        

    }
    
    // Answer Logic Parse 1 - Answer contains correct letters c.f. question
    func isPossible(word: String) -> Bool {
        // Store the question word in a temporary variable that can be safely mutated when checked against
        var tempWord = title!.lowercased()
        // Loop through the letters in the answer
        for letter in word {
            // Check to see if each letter (note casting of Char to String) appears in the question word
            if let pos = tempWord.range(of: String(letter)) {
                // If so remove this letter from the temporary question word
                tempWord.remove(at: pos.lowerBound)
            } else {
                // Else if the letter was not in (or all of same letter has been used) question, do not pass this test
                return false
            }
        }
        // If we get to here, the answer is a possible anagram
        return true
    }
    
    // Answer Logic Parse 2 - An original anagram not already used
    func isOriginal(word: String) -> Bool {
        // Check the answer word isn't just the question word
        if word.contains(title!.lowercased()) {
            return false
        }
        
        // Simple check to see if usedWords array contains the newly input answer
        return !usedWords.contains(word)
    }
    
    // Answer Logic Parse 3 - Is the answer a real word?
    func isReal(word: String) -> Bool {
        // Check answer is >3 characters
        if word.count <= 3 {
            return false
        }
        
        // Create an instance of the UITextChecker that can be used to spot spelling errors
        let checker = UITextChecker()
        // Create a string with some range
        let range = NSMakeRange(0, word.utf16.count)
        // Check where, if at all, a mispelled (or in this case false answer) word exists within the range
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0,
                                                           wrap: false, language: "en")
        // If no misspelling/incorrect answer, above method returns NSNotFound, i.e. the answer is a correct word
        
        return mispelledRange.location == NSNotFound
    }
    
    // Method for showing an error message
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // Method for loading default word list if loading from file fails
    func loadDefaultWords() {
        allWords = ["silkworm"]
    }
    
    // MARK: - Selector Methods
    // Method for positng an answer navbar
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    // Method for starting a new game from navbaR
    @objc func newGame() {
        startGame()
    }
    
    // MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self,
                                                           action: #selector(newGame))
        
        // Extract words from file of all words in game
        // 1. Find the path to the resource (start.txt is located within the main bundle)
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            // 2. Try to read in constents of file as a string
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                // 3. Split contents of file into components separated by new line character
                // and assign it to the VC property storing allWords in the game.
                allWords = startWords.components(separatedBy: "\n")
            } else {
                loadDefaultWords()
            }
        } else {
            // 4. For some reason couldn't get at the file so manually add element to allWords array so game
            // doesn't completely break.
            loadDefaultWords()
        }
        
        startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

