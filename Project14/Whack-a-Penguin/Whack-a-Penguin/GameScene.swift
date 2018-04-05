//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by Ben Hall on 04/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
// MARK: - Future ideas
// TODO: - Start new game and save high score to user defaults
// TODO: - Particle effects (e.g. smoke) when enemy hit and mud-like effect when re-entering a hole
// TODO: - Record Game over sounds and play.
// TODO: - Difficulty levels by slowing/speeding up animations

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    // Create array to store slots
    var slots = [WhackSlot]()
    
    // What initial delay to show penguins?
    var popupTime = 0.85
    
    // Limit number of rounds in game so it doesn't go on ad infinitum
    var numRounds = 0
    
    // MARK: - Custom methods
    // Function for creating slots
    func createSlot(at position: CGPoint) {
        // Instantiate a slot
        let slot = WhackSlot()
        // Give it a position
        slot.configure(at: position)
        // Add node to scene
        addChild(slot)
        // Add slot to array of slots
        slots.append(slot)
    }
    
    // Function for creating enemies
    func createEnemy() {
        // Incrememnt number of rounds everytime an enemy is created
        numRounds += 1
        // After 30 enemies have been created end game
        if numRounds >= 30 {
            // Remove all slots from play
            for slot in slots {
                slot.hide()
            }
            
            // Display gameover sprite/node
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            // Set position
            gameOver.position = CGPoint(x: 512, y: 384)
            // Set on foremost zlayer
            gameOver.zPosition = 1
            // Add to scene
            addChild(gameOver)
            
            // exit
            return
        }
        
        // Decrease the popup time (game gets quicker as it progresses)
        popupTime *= 0.991
        
        // Shuffle the array of slots
        slots = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: slots) as! [WhackSlot]
        // Pick the first of these shuffled slots to display an enemy from
        slots[0].show(hideTime: popupTime)
        
        // Randomly determine if multiple other enemies should appear
        if RandomInt(min: 0, max: 12) > 4 { slots[1].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 8 { slots[2].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime) }
        
        // Determine the appearance delay from a random value between popupTime/2 to popupTime * 2
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = RandomDouble(min: minDelay, max: maxDelay)
        
        // Delay the appearance of enemies by the random delay. This will recursively keep calling the method
        // continuing the game ad infinitum
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            self.createEnemy()
        }
    }
    
    override func didMove(to view: SKView) {
        // Set the background
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Game score label
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        // Add 4 rows of slots to scene with 5-4-5-4 row layout
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        // Start the game with a 1 set delay so user can acclimatise
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            self.createEnemy()
        }

    }

    // Here we deal with user interactions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get first touch
        if let touch = touches.first {
            // get location of touch
            let location = touch.location(in: self)
            // Determine nodes that were touched at this location
            let tappedNodes = nodes(at: location)
            
            // Loop through the tapped nodes to determine what was touched
            for node in tappedNodes {
                if node.name == "charFriend" {
                    // Shouldn't have hit this
                    // Get the parent WhackSlot node of this penguin
                    let whackSlot = node.parent!.parent as! WhackSlot
                    // If this slot is not visible, skip
                    if !whackSlot.isVisible { continue }
                    // If the penguin has been hit, skip
                    if whackSlot.isHit { continue }
                    
                    // Run the hit method of whackSlot to make the penguin hide itself
                    whackSlot.hit()
                    // Subtract from the score
                    score -= 5
                    
                    // Play a sound related to bad hit
                    run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                    
                } else if node.name == "charEnemy" {
                    // Bonza!
                    // Get parent node again
                    let whackSlot = node.parent!.parent as! WhackSlot
                    // Check if it is not visible (exit if so)
                    if !whackSlot.isVisible { continue }
                    // Check if it has been hit (exit if so)
                    if whackSlot.isHit { continue }
                    
                    // Scale the enemy node down to give impression it has been hit
                    whackSlot.charNode.xScale = 0.85
                    whackSlot.charNode.yScale = 0.85
                    
                    // Play the hitting method
                    whackSlot.hit()
                    
                    // Increment the score
                    score += 1
                    
                    // Play victory sound
                    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                }
            }
        }
        
    }
    

}
