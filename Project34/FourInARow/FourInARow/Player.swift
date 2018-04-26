//
//  Player.swift
//  FourInARow
//
//  Created by Ben Hall on 26/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
//  Model file describing players in game

import UIKit
import GameplayKit

class Player: NSObject, GKGameModelPlayer {
    
    // Instance Properties
    var chip: ChipColor // The player's chip type
    var color: UIColor // The color of the players chips (for UI)
    var name: String // The name of the player
    var playerId: Int // The id of the player used by GamplayKit
    var opponent: Player { // Return the opponent to current player
        if chip == .red {
            return Player.allPlayers[1]
        } else {
            return Player.allPlayers[0]
        }
    }
    
    // Class Properties
    static var allPlayers = [Player(chip: .red), Player(chip: .black)] // an array of all active players
    
    // Inits
    init(chip: ChipColor) {
        self.chip = chip
        self.playerId = chip.rawValue // since I player won't have a ChipColor = .none, this will be 1 (.red) or 2 (.black)
        
        if chip == .red {
            self.color = .red
            self.name = "Red"
        } else {
            self.color = .black
            self.name = "Black"
        }
        
        super.init()
    }
    
}
