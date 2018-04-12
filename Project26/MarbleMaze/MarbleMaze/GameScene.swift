//
//  GameScene.swift
//  MarbleMaze
//
//  Created by Ben Hall on 12/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
// TODO: - Refactor loadLevel() to be less, well, dense... (i.e. several smaller methods)
// TODO: - New levels loaded when finish flag reached
// TODO: - More gameplay elements (teleport?)


// NOTES
// categoryBitMask - number that defines the type of object this is for considering collisions
// collisionBitMask - number defining what categories of object this node should collide with
// contactTestBitMask - number defining which collisions we want to be notified about

// Every node to be registered by collisions needs a categoryBitMask
// If you gave nodes a collision but not contact bit mask, nodes will bounce off each other, but won't be
// notified about it. Vice versa, no collisions, but will be notified when they overlap.

// Default behaviour - Every node has a collisionBitMask that means "everything" and contact of "nothing"

import CoreMotion // For tracking tilts in this app
import SpriteKit
import GameplayKit

// This enum is for describing the categoryBitMasks (what collides with what)
enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: - Game control properties
    var motionManager: CMMotionManager!
    
    // MARK: - Game properties
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isGameOver = false // Tracks whether the game has ended
    
    // MARK: - Game methods
    // This long function handles loading a level and all nodes within it
    func loadLevel() {
        // Get the text file that describes the level layout
        if let levelPath = Bundle.main.path(forResource: "level1", ofType: "txt") {
            // Try and read the entire contents of file to memory
            if let levelString = try? String(contentsOfFile: levelPath) {
                // Break this into an array of each new line
                let lines = levelString.components(separatedBy: "\n")
                // Loop through each line of file to determine the layout of nodes in each row
                // (reversed to fill in from bototm to top
                for (row, line) in lines.reversed().enumerated() {
                    // and loop through each line for layout of nodes in row
                    for (column, letter) in line.enumerated() {
                        // Set the position of where the node will be drawn
                        // each node will be 64x64points
                        let position = CGPoint(x: (column * 64) + 32, y: (64 * row) + 32)
                        
                        // Now get drawing the nodes
                        if letter == "x" {
                            // draw wall
                            let node = SKSpriteNode(imageNamed: "block")
                            node.position = position
                            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                            node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                            node.physicsBody?.isDynamic = false
                            addChild(node)
                        } else if letter == "v" {
                            // draw vortex
                            let node = SKSpriteNode(imageNamed: "vortex")
                            node.name = "vortex"
                            node.position = position
                            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody?.isDynamic = false
                            node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                            // Want to be notified when player contacts with vortex
                            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            addChild(node)
                        } else if letter == "s" {
                            // draw star
                            let node = SKSpriteNode(imageNamed: "star")
                            node.name = "star"
                            node.position = position
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody?.isDynamic = false
                            node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            addChild(node)
                        } else if letter == "f" {
                            // draw the finish
                            let node = SKSpriteNode(imageNamed: "finish")
                            node.name = "finish"
                            node.position = position
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2 )
                            node.physicsBody?.isDynamic = false
                            node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            addChild(node)
                        }

                    }
                }
            }
        }
    }
    
    // This will create the player node and add it to the scene
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false //(stop rotation around z axis)
        player.physicsBody?.linearDamping = 0.5 // Give the ball some friction
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        // Player can contact Star, Vortex, and Finish
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        // Player can collide with walls
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    // Runs when player collides with something
    func playerCollided(with node: SKNode) {
        // If collide with VORTEX
        if node.name == "vortex" {
            // Stop ball from being dynamic (stops)
            player.physicsBody?.isDynamic = false
            isGameOver = true // set game over state
            score -= 1 // decrement score
            
            // Animate ball to being sucked into vortex
            let move = SKAction.move(to: node.position, duration: 0.25) // move ball over vortes
            let scale = SKAction.scale(to: 0.0001, duration: 0.25) // scale ball down
            let remove = SKAction.removeFromParent() // remove ball from scene
            let sequence = SKAction.sequence([move,scale,remove])

            player.run(sequence) { [unowned self] in
                self.createPlayer() // Reccreate player after sequence
                self.isGameOver = false // Set game over state to false
            }
            
            // Create player ball again and re-enable control
        } else if node.name == "star" {
            // Remove star from game and increment score
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // Reached end of level, reload level?
            // TODO: Implement gameover, new levels to load etc.
        }
    }
    
    // MARK: -  Physics World contactDelegate methods
    // Determine what contacted what?
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == player {
            playerCollided(with: contact.bodyB.node!)
        } else if contact.bodyB.node == player {
            playerCollided(with: contact.bodyA.node!)
        }
    }
    
    override func didMove(to view: SKView) {
        // Decome contactDelegate to the physicsworld (i.e. we want to know when contact between nodes occcurs)
        physicsWorld.contactDelegate = self
        
        // Remove the default gravity of the game
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // Set the background of the scene
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Add a score label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        // Load the level
        loadLevel()
        
        // Load the player
        createPlayer()
        
        // Implement player motion via CoreMotion tracking of accelerometer
        motionManager = CMMotionManager() // Get instance of CM Motion manager
        motionManager.startAccelerometerUpdates() // Start tracking accelerometer
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
        // Don't update anymore if game has ended
        guard isGameOver == false else { return }
        
        // Poll the motion manager to see what the current tilt data is
        if let accelerometerData = motionManager.accelerometerData {
            // NOTE accelerometer X and Y axis are with respect to portrait orientation
            //      we are in landscape where so  need to swap them arround.
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50,
                                            dy: accelerometerData.acceleration.x * 50)
        }
        
        
    }
}
