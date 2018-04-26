//
//  Board.swift
//  FourInARow
//
//  Created by Ben Hall on 25/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
//  Model file - Storeswhere the chips are and who is winning

import UIKit

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
    
    // MARK: - Inits
    override init() {
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
    
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    func add(chip: ChipColor, in column: Int) {
        if let row = nextEmptySlot(in: column) {
            set(chip: chip, in: column, row: row)
        }
    }

    // Check for whether the board is full - NOT IMPLEMENTED
    func isFull() -> Bool {
        return false
    }
    
    // Check for whether a player has won - NOT IMPLEMENTED
    func isWin(for player: Player) -> Bool {
        return false
    }
}
