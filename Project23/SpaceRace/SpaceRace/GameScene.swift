//
//  GameScene.swift
//  SpaceRace
//
//  Created by Ben Hall on 11/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    // Basic Elements
    var starField: SKEmitterNode! // Dynamic background
    var player: SKSpriteNode! // Player sprite
    
    var scoreLabel: SKLabelNode! // Score label
    var score = 0 { // property observer that updates score label
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // Gameplay elements
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer!
    var isGameOver = false
    
    // MARK: - Custom methods
    @objc func createEnemy() {
        // Shuffle the possible enemy types
        possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleEnemies) as! [String]
        
        // Create a random distribution between two values that will specify the vertical position
        // of where the enemy appears
        let randomDistribution = GKRandomDistribution(lowestValue: 50, highestValue: 736)
        
        // Create sprite node for the enemy
        let sprite = SKSpriteNode(imageNamed: possibleEnemies[0])
        sprite.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
        addChild(sprite)
        
        // Give some collision physics to the sprite
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size) //per-pixel approx again
        sprite.physicsBody?.categoryBitMask = 1 // belong to same category as plater contactTestBitMask
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0) // give it some speed
        sprite.physicsBody?.angularVelocity = 5 // give it some spin
        sprite.physicsBody?.linearDamping = 0 // stop movement from slowing with time
        sprite.physicsBody?.angularDamping = 0 // stop rotation from slowing with time
  
    }
    
    override func didMove(to view: SKView) {
        // Set up the background
        backgroundColor = .black
        starField = SKEmitterNode(fileNamed: "Starfield")
        starField.position = CGPoint(x: 1027, y: 384)
        starField.advanceSimulationTime(10) // This essentially shows the emitter 10s after it has already started
        addChild(starField)
        starField.zPosition = -1
        
        // Add the player node
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size) // Approx hitbox to shape of sprite
        player.physicsBody?.contactTestBitMask = 1 // This will match the junk later so they can collide
        addChild(player)
        
        // Add the score node
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        // Update the score label
        score = 0
        
        // Remove gravity from the scene (we are in space!)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self // So we can communicate with physicsWorld when collisions occur
        
        
        // Create timer
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self,
                                         selector: #selector(createEnemy), userInfo: nil,
                                         repeats: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Remove nodes out of scene from play
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        // If the game isn't over, update the score!
        if !isGameOver {
            score += 1
        }
    }
}
