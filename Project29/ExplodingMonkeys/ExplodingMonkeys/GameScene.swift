//
//  GameScene.swift
//  ExplodingMonkeys
//
//  Created by Ben Hall on 16/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit
import GameplayKit

// Enum for collision bitmask groups
enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - VC delegation
    weak var viewController: GameViewController!
    
    // MARK: - Properties
    var buildings = [BuildingNode]()
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    var currentPlayer = 1
    
    // MARK: - Utility methods
    func deg2rad(degrees: Int) -> Double { return (Double.pi / 180.0) * Double(degrees) }
    
    // MARK: - Set-up methods
    func createBuildings() {
        // add buildings to scene spaced horizontally starting slighlty off screen (x: -15) up until far edge
        // give 2 point gap between buildings
        
        // Buildings will be randome size.
        // Height -> 300 - 600
        // Width -> Divide evenly by 40 (for window drawing) (gen no. between 2 ... 4 and x40)
        
        var currentX: CGFloat = -15
        while currentX < 1024 {
            let size = CGSize(width: RandomInt(min: 2, max: 4) * 40,
                              height: RandomInt(min: 300, max: 600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1] // Position player one 2nd building from left
        player1.position = CGPoint(x: player1Building.position.x,
                                   y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        // and for player 2 - eww this most likely can be refactored to less code as it is mostly the same as above
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x,
                                   y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    func changePlayer() {
        currentPlayer = currentPlayer == 1 ? 2 : 1
        viewController.activatePlayer(number: currentPlayer)
    }
    
    // MARK: - Game methods
    
    // Responsible for actually launching projectile bananas from players
    func launch(angle: Int, velocity: Int) {
        // 1. Determine how hard to throw banana
        let speed = Double(velocity) / 10.0
        
        // 2. Convert angle slider input into radians
        let radians = deg2rad(degrees: angle)
        
        // 3. If banana somehow still exists, remove from scene and create new one with circle hit box
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true // Better for smaller objects in a scene, but also more intensive, so use conservatively
        addChild(banana)
        
        
        let player = currentPlayer == 1 ? player1! : player2!
        let bananaPosition = currentPlayer == 1 ? CGPoint(x: -30, y: 40) : CGPoint(x: 30, y: 40)
     
        
        banana.position = CGPoint(x: player.position.x + bananaPosition.x, y: player.position.y + bananaPosition.y)
        banana.physicsBody?.angularVelocity = currentPlayer == 1 ? -20 : 20
        
        let raiseArm = SKAction.setTexture(SKTexture(imageNamed: currentPlayer == 1 ? "player1Throw" : "player2Throw"))
        let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
        let pause = SKAction.wait(forDuration: 0.15)
        let sequence = SKAction.sequence([raiseArm, lowerArm, pause])
        player1.run(sequence)
        
        let impulse = CGVector(dx: (currentPlayer == 1 ? 1 : -1) * speed * cos(radians), dy: speed * sin(radians))
        banana.physicsBody?.applyImpulse(impulse)
        
//        if currentPlayer == 1 {
//            // 4. If P1 turn, projectile positions up and to left of player with some spin
//            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
//            banana.physicsBody?.angularVelocity = -20
//
//            // 5. Animate P1 throwing their arm up and putting down (change texture)
//            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
//            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
//            let pause = SKAction.wait(forDuration: 0.15)
//            let sequence = SKAction.sequence([raiseArm, lowerArm, pause])
//            player1.run(sequence)
//
//            // 6. Make banana move in correct direction
//            let impulse = CGVector(dx: speed * cos(radians), dy: speed * sin(radians))
//            banana.physicsBody?.applyImpulse(impulse)
//        } else {
//            // 7. If P2, position up and to right, apply opposite spin, and motion in correct direction
//            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
//            banana.physicsBody?.angularVelocity = 20
//
//            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
//            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
//            let pause = SKAction.wait(forDuration: 0.15)
//            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
//            player2.run(sequence)
//
//            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
//            banana.physicsBody?.applyImpulse(impulse)
//        }
        

    }
    
    // Responsible for destroying player when hit by banana
    func destroy(player: SKSpriteNode) {
        // Create explosion (SKEmitterNode)
        let explosion = SKEmitterNode(fileNamed: "hitPlayer")!
        explosion.position = player.position
        addChild(explosion)
        
        // Remove destroyed player and banana from scene
        player.removeFromParent()
        banana?.removeFromParent()
        
        // Game over for one player, transition to a new game
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            let newGame = GameScene(size: self.size) // Create new GameScene with same size as current scene
            newGame.viewController = self.viewController // Make sure connection to viewController UI is handed over (this one is weak(
            self.viewController.currentGame = newGame // And make a strong connection between the VC and newGame
            
            self.changePlayer() // change the player from winner to loser
            newGame.currentPlayer = self.currentPlayer // set new games current plater to the new one (loser gets to go first)
            
            // transition to new scene
            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
    // Responsible for damaging a building when hit by banana
    func bananaHit(building: BuildingNode, atPoint contactPoint: CGPoint) {
        let buildingLocation = convert(contactPoint, to: building) // convert the contact point to building node coordinates
        building.hitA(point: buildingLocation)
        
        // Create an explosion at contact point
        let explosion = SKEmitterNode(fileNamed: "hitBuilding")!
        explosion.position = contactPoint
        addChild(explosion)
        
        // Remove banana from sweet
        banana.name = "" // this is done so that if banana hits more than one building at same time, only one explosion happens
        banana?.removeFromParent()
        banana = nil
        
        changePlayer() // Change the player for the next turn
    }
    
    // MARK: - PhysicsWorld Contact delegate methods
    
    // Called when some kind of collision occurred
    func didBegin(_ contact: SKPhysicsContact) {
        // Set variables that will associate which bodies contact with which
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // Will set the lowest ranking CollisionType category always to being the first body (banana = 1, building = 2, player = 4)
        // Thus player/building will always be the second body, and banana will be the first
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Check we have a firstbody collision node
        if let firstNode = firstBody.node {
            // and a second node
            if let secondNode = secondBody.node {
                // Banana hit a building!
                if firstNode.name == "banana" && secondNode.name == "building" {
                    bananaHit(building: secondNode as! BuildingNode, atPoint: contact.contactPoint)
                }
                // Banana hit player1
                if firstNode.name == "banana" && secondNode.name == "player1" {
                    destroy(player: player1)
                }
                // Banana hit player2
                if firstNode.name == "banana" && secondNode.name == "player2" {
                    destroy(player: player2)
                }
            }
        }
        
    }
    
    // MARK: - SK lifecycle methods
    override func didMove(to view: SKView) {
        // Make this GameScene the contactDelegate for the physicsWorld
        physicsWorld.contactDelegate = self
        
        // Create a background
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        // Create buildings
        createBuildings()
        
        // Create players
        createPlayers()
        
        // Need to determine what hits what
        // banana <-> building
        // banana <-> player1
        // banana <-> player2
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Remove bananas that fly off screen and start next player's turn
        if banana != nil {
            if banana.position.y < -1000 {
                banana.removeFromParent()
                banana = nil
                changePlayer()
            }
        }
    }
}
