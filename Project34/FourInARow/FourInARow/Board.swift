//
//  Board.swift
//  FourInARow
//
//  Created by Ben Hall on 25/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
//  Model file - Storeswhere the chips are and who is winning

import UIKit
import GameplayKit

// MARK: - Enums

// This enum defines the types of chips that can be in play
enum ChipColor: Int {
    case none = 0
    case red
    case black
}

class Board: NSObject {

    // MARK: - Class Properties
    static var width = 7
    static var height = 6
    
    // MARK: - Instance Properties
    var slots = [ChipColor]()
    var currentPlayer: Player
    
    // MARK: - Inits
    override init() {
        // Set the initial player
        self.currentPlayer = Player.allPlayers[0]
        
        // Set all slots available on the board to have no chips in them
        for _ in 0 ..< Board.width * Board.height {
            slots.append(.none)
        }
        
        super.init()
    }
    
    // MARK: - Instance methods
    
    // Gets what chip type exists at a particular column and row
    func chip(inColumn column: Int, row: Int) -> ChipColor {
        return slots[row + column * Board.height]
    }
    
    // Sets what chip type is in a specific column and row
    func set(chip: ChipColor, in column: Int, row: Int) {
        slots[row + column * Board.height] = chip
    }
    
    // Determine if a player can place a chip in a particular slot
    // For an input column, returns which row a chip can be placed (if at all, hence optional)
    func nextEmptySlot(in column: Int) -> Int? {
        for row in 0 ..< Board.height {
            if chip(inColumn: column, row: row) == .none {
                return row
            }
        }
        
        return nil
    }
    
    // Check to see if a move is possible within a specific column
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    // Add a chip to the model board in the next empty slot within a spiecified column
    func add(chip: ChipColor, in column: Int) {
        if let row = nextEmptySlot(in: column) {
            set(chip: chip, in: column, row: row)
        }
    }

    // Check for whether the board is full
    func isFull() -> Bool {
        // Check each column on the board to see if it is full of chips
        for column in 0 ..< Board.width {
            // If a move can be made, the board is not full
            if canMove(in: column) {
                return false
            }
        }
        
        return true
    }
    
    // For input chip, checks on chip color, row/column of chip, and x/y movement of chip
    // to see if a 4 in a row match has been made. The x, y movement inputs are used to run
    // this method multiple times. shifting column row location checking for a matching chip
    // in any direction.
    func squaresMatch(initialChip: ChipColor, row: Int, col: Int, moveX: Int, moveY: Int) -> Bool {
        // 1. Bail out if try to check out of bounds
        if row + (moveY * 3) < 0 { return false } // (moveXY * 3 checks the exteme position of 4 in a row for out of bounds)
        if row + (moveY * 3) >= Board.height { return false }
        if col + (moveX * 3) < 0 { return false }
        if col + (moveX * 3) >= Board.width { return false }
        
        // 2. Not out of bounds check chips in adjacent directions to see if there is a different chip
        //    occupying a position.
        if chip(inColumn: col, row: row) != initialChip { return false } //
        if chip(inColumn: col + moveX, row: row + moveY) != initialChip { return false }
        if chip(inColumn: col + (moveX * 2), row: row + (moveY * 2)) != initialChip { return false }
        if chip(inColumn: col + (moveX * 3), row: row + (moveY * 3)) != initialChip { return false }
        
        // 3. Passed above checks, we have a match for input moveXY positions.
        return true
    }
    
    // Check for whether a player has won - NOT IMPLEMENTED
    func isWin(for player: GKGameModelPlayer) -> Bool {
        // extract chip from player via typecasting GKGameModelPlayer back to Player class
        let chip = (player as! Player).chip
        
        for row in 0 ..< Board.height {
            for col in 0 ..< Board.width {
                if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 0) {
                    // Horizontal 4 in a row found!
                    print("Horiz 4")
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 0, moveY: 1) {
                    // Vertical four in a row found!
                    print("Vert 4")
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 1) {
                    // Diagonal up four in a row found!
                    print("Diag up 4")
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: -1) {
                    // Diagonal down four in a row found
                    print("Diag down 4")
                    return true
                }
            }
        }
        
        return false
    }
    

}
