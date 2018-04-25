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

}

