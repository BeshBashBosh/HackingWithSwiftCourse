//
//  ViewController.swift
//  FourInARow
//
//  Created by Ben Hall on 25/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    var placedChips = [[UIView]]()
    var board: Board!
    
    // MARK: - Outlets
    @IBOutlet var columnButtons: [UIButton]!
    
    // MARK: - Actions
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: .red, in: column)
            self.addChip(inColumn: column, row: row, color: .red)
        }
    }
    
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add empty UIView arrays to placedChips array for each board column
        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }
        
        // Reset the board
        resetBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Instance Methods
    
    // Method to reset the board at start of new game
    func resetBoard() {
        // Create new instance of the board
        board = Board()
        
        // Remove any already existing chips from play
        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }
            
            // Remove the chips from the placedChips array
            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    // Add a chip view to the UI
    func addChip(inColumn column: Int, row: Int, color: UIColor) {
        let button = columnButtons[column] // Extract the column button
        let size = min(button.frame.width, button.frame.height / 6) // Set the size of the chip
        let rect = CGRect(x: 0, y: 0, width: size, height: size) // Create a chip based on a rectangle
        
        if (placedChips[column].count < row + 1) { // if column is not filled with chips
            let newChip = UIView() // create a UIView representing the chip
            newChip.frame = rect // Set its frame to that of the rectangle defined earlier
            newChip.isUserInteractionEnabled = false // Don't let the user interact with it
            newChip.backgroundColor = color // Set its color based on function call
            newChip.layer.cornerRadius = size / 2 // Set a corner radius that will make it a circle
            newChip.center = positionForChip(inColumn: column, row: row) // set where it should be positioned
            newChip.transform = CGAffineTransform(translationX: 0, y: -800) // start with the chip off screen
            view.addSubview(newChip) // add chip to the UI (still offscreeen)
            
            // Animate the view from off screen into the column
            // .curveEaseInm animation starts slow and speeds up
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })
            
            // Add this new chip to the placed chips array
            placedChips[column].append(newChip)
        }
    }
    
    // Determine the position a chip should be placed in
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        // 1. Extract UIButton representing input column
        let button = columnButtons[column]
        
        // 2. Set chip size to be either width of column button, or height of column divided by 6 (6 full rows), whichever smallest
        let size = min(button.frame.width, button.frame.height / 6)
        
        // 3. Use midX to get horizontal center of column button (x pos of chip)
        let xOffset = button.frame.midX
        
        // 4. Use maxY to get bottom of column button, subtract half chip size (working with center position of chip)
        var yOffset = button.frame.maxY - size / 2
        
        // 5. Multiply row by size of each chip to find offset of new chip. Subtract the maxY position
        yOffset -= size * CGFloat(row)
        
        // 6. Create a CGPoint defined by these positions and return.
        return CGPoint(x: xOffset, y: yOffset)
    }

    // Progress the game. Called each turn and ends the game if necessary
    func continueGame() {
        // 1. Create gameOverTitle optional string
        var gameOverTitle: String? = nil
        // 2. If game over or board full, gameOverTitle updated to include relevant status message
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }
        
        // 3. If game over (won or drawn), show alert controller that resets board when dismissed
        if gameOverTitle != nil {
            let ac = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Play Again", style: .default) { [unowned self] (action) in
                self.resetBoard()
            }
            ac.addAction(alertAction)
            present(ac, animated: true)
            
            return // exit method now!
        }
        
        // 4. Otherwise change current player of game, update UI with player
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
        
    }
    // Update the UI state with user guiding information
    func updateUI() {
        title = "\(board.currentPlayer.name)'s Turn"
    }
    
    
}

