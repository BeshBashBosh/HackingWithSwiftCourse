//
//  GameScene.swift
//  MarbleMaze
//
//  Created by Ben Hall on 12/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

// NOTES
// categoryBitMask - number that defines the type of object this is for considering collisions
// collisionBitMask - number defining what categories of object this node should collide with
// contactTestBitMask - number defining which collisions we want to be notified about

// Every node to be registered by collisions needs a categoryBitMask
// If you gave nodes a collision but not contact bit mask, nodes will bounce off each other, but won't be
// notified about it. Vice versa, no collisions, but will be notified when they overlap.

// Default behaviour - Every node has a collisionBitMask that means "everything" and contact of "nothing"

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

class GameScene: SKScene {

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
    
    override func didMove(to view: SKView) {
        loadLevel()
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
    }
}
