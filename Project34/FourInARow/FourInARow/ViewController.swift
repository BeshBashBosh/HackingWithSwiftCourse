//
//  ViewController.swift
//  FourInARow
//
//  Created by Ben Hall on 25/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    // MARK: - Properties
    var placedChips = [[UIView]]()
    var board: Board!
    
    // MARK: - Gameplay kit AI
    var strategist: GKMinmaxStrategist!
    
    // MARK: - Outlets
    @IBOutlet var columnButtons: [UIButton]!
    
    // MARK: - Actions
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column) // add chip to board model
            self.addChip(inColumn: column, row: row, color: board.currentPlayer.color) // sync UI to model
            self.continueGame() // advance the game
        }
    }
    
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add empty UIView arrays to placedChips array for each board column
        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }
        
        // Create the GK ai strategist
        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = 7 // how many turns ahead the strategist will look
        // what to do if a tiebreaker between two equally good moves
        // if nil will pick the first occurring best move
        // if wanted AI to randomly select best move, could do .randomSource = GKArc4RandomSource()
        strategist.randomSource = GKARC4RandomSource()
        
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
        
        // Feed the GK strategist AI some data, in this case the gameModel (or Board instance here!)
        strategist.gameModel = board
        
        self.updateUI() // update the title of the view
        
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
        
        // Kick off the AI move!!
        if board.currentPlayer.chip == .black {
            startAIMove()
        }
    }
    
    
    // MARK: - GK AI MinmaxStrategist related methods
    // This will evaluate the best move to make and either return what column this is in, or nil
    // if none can be found. Will run this method on background thread as it may take a while to compute
    func columnForAIMove() -> Int? {
        if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
            return aiMove.column
        }
        
        return nil
    }
    
    // Makes the AI move for best column determined from columnForAIMove method
    func makeAIMove(in column: Int) {
        // re-enable buttons (disabled in startAIMove)
        columnButtons.forEach { $0.isEnabled = true }
        // disable AI thinking spinner
        navigationItem.leftBarButtonItem = nil
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            self.addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            
            self.continueGame()
        }
    }
    
    // Kicks off the AI's move with above methds
    func startAIMove() {
        // disable columnButtons whilst AI 'thinks' so that user can't keep placing pieces
        columnButtons.forEach { $0.isEnabled = false }
        // add a spinner to show AI is thinking
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
        
        // 1. Dispatch columnForAIMove to background thread
        DispatchQueue.global().async { [unowned self] in
            // 2. Get current time, then run columnForAIMove
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let column = self.columnForAIMove() else { return }
            
            // 3. Get time again, compare difference, subtract value from 1 to form a delay value
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            let aiTimeCeiling = 1.0
            let delay = aiTimeCeiling - delta // delay exists to wait at least 1s before move is made as not to confuse real player.
            
            // 4. Run makeAIMove(in:) on main thread after delay to execute move
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.makeAIMove(in: column)
            }
        }
    }
    
    
}

