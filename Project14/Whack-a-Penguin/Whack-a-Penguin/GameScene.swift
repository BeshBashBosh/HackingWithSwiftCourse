//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by Ben Hall on 04/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit


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
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    

}
