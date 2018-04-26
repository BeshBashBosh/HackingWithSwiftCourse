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

class Board: NSObject, GKGameModel {
    
    // MARK: - Class Properties
    static var width = 7
    static var height = 6
    
    // MARK: - Instance Properties
    var slots = [ChipColor]()
    var currentPlayer: Player
    
    // MARK: - GameplayKit properties
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
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
    
    // MARK: - NSCopying conformity methods
    // Needed by our AI to make copies of the Board model and record gamestate for evaluating potential moves
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }
    
    // MARK: - GKGameModel conformity methods
    // Set's the current state of the Game model
    func setGameModel(_ gameModel: GKGameModel) {
        if let board = gameModel as? Board {
            slots = board.slots
            currentPlayer = board.currentPlayer
        }
    }
    
    // Determines which moves can be made by the AI and should be tested
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        // 1. Downcast player <GKGameModelPlayer> as Player object
        if let playerObject = player as? Player {
            // 2. If Player or opponenet has won, return nil to signal no moves possible
            if self.isWin(for: playerObject) || self.isWin(for: playerObject.opponent) {
                return nil
            }
            
            // 3. Else create new array to hold Move objects to be determined by GK AI
            var moves = [Move]()
            
            // 4. Loop through each column on board, determining if player can move to position
            for col in 0 ..< Board.width {
                if self.canMove(in: col) {
                    // 5. If yes, create new Move object for that column and add to array
                    moves.append(Move(column: col))
                }
            }
    
            // 6. Return array of all possible moves for AI to evaluate
            return moves
        }
        
        return nil
        
    }
    
    // Get's the AI to apply the moves determined by the gameModelUpdates(player:) method
    // to determine the 'best' move to take
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        // Play out the move on the AI's copy of the game state
        if let move = gameModelUpdate as? Move {
            self.add(chip: currentPlayer.chip, in: move.column)
            currentPlayer = currentPlayer.opponent
        }
    }
    
    // Scoring method required for GK AI to determine whether a move is good or not
    // This game has no real score so will mark as if:
    //      player win - score 1000 awarded
    //      opponent win - score of -1000 to player
    //      if neither - score of 0
    func score(for player: GKGameModelPlayer) -> Int {
        if let playerObject = player as? Player {
            if isWin(for: playerObject) {
                return 1000
            } else if isWin(for: playerObject.opponent) {
                return -1000
            }
        }
        return 0
    }
    


}
