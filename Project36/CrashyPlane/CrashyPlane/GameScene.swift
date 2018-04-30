//
//  GameScene.swift
//  CrashyPlane
//
//  Created by Ben Hall on 27/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Instance Properties
    var player: SKSpriteNode!
    
    
    // MARK: - Composed Methods
    
    // Adds a player to the scene
    func createPlayer() {
        // Create the player node from initial texture
        let playerTexture = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 5, y: frame.height * 0.75)
        addChild(player)
        
        // Animate the player texture
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        player.run(runForever)
    }
    
    // Creates the nodes for the background sky
    func createSky() {
        // Create the top portion of sky from a color and size 67% height of the frame
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1),
                                  size: CGSize(width: frame.width, height: frame.height * 0.67))
        // Change anchor point of sky node from centre to centre in x, top in y, makes positioning easier
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // Create bottom part of sky and change anchor point as above
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1),
                                     size: CGSize(width: frame.width, height: frame.height * 0.33))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // set position of sky nodes in frame
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
        
        // Add nodes to the scene
        addChild(topSky)
        addChild(bottomSky)
        
        // Set zposition to far background for parallax effect with other layers
        bottomSky.zPosition = -40
        topSky.zPosition = -40
        
    }
    
    // Create nodes for infinite background
    func createBackground() {
        // Create texture for background image
        let backgroundTexture = SKTexture(imageNamed: "background")
        // To give effect of infinite background will loop through two background nodes, interchanging them when one goes off scrren
        for i in 0 ... 1 {
            // Create background node
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30 // set zposition in background but ahead of sky background
            background.anchorPoint = CGPoint.zero // set anchor point to bottom left
            
            // Calculate the initial x position of the node
            // for node 0 (first loop iteration) horiz position at anchor point (0,0)
            // for node 1 (second loop iteration) horiz position at width of texture minus a small amount (1) to stop any small gaps
            let backgroundHorizPosition = (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i)
            background.position = CGPoint(x: backgroundHorizPosition, y: 100)
            addChild(background)
            
            // Create animations for the nodes
            // 1. moves node to left of screen by the texture size over period 20s
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width,
                                           y: 0, duration: 20)
            // 2. Resets the position of the node
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width,
                                            y: 0, duration: 0)
            // 3. Put above in sequence
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            // 4. tell the animation sequence to repeat ad infinitum
            let moveForever = SKAction.repeatForever(moveLoop)
            // 5. Run the animation
            background.run(moveForever)
        }
    }
    
    // Create nodes for infinite ground
    func createGround() {
        // Same technique as in createBackground
        let groundTexture = SKTexture(imageNamed: "ground")
        
        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            // Set horizontal position of node
            // 1. node 0 (first loop iter) at anchor point (0.5,0.5)
            // 2. node 1 (second loop iter) to the right of first node
            let backgroundHorizPosition = (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i)))
            ground.position = CGPoint(x: backgroundHorizPosition, y: groundTexture.size().height / 2)
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width,
                                           y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width,
                                            y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
        }
    }
    
    // Create nodes for rocks that player needs to avoid
    func createRocks() {
        // 1. Create top and bottom rock nodes, same node, one rotated
        let rockTexture = SKTexture(imageNamed: "rock")
        
        let bottomRock = SKSpriteNode(texture: rockTexture)
        bottomRock.zPosition = -20 // behind the ground sprites
        
        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.zPosition = -20
        topRock.zRotation = .pi
        topRock.xScale = -1.0 // normally this scales the node horizontally. Here, a value of -1 inverts it!
        
        // 2. Create large red rectangle, positioned just after rocks, will track if player has succesfully passed through
        //    obstacle unscathed. Essentially, touch rectangle, score a point!
        let rockCollision = SKSpriteNode(color: .red, size: CGSize(width: 32, height: frame.height))
        rockCollision.name = "scoreDetect"
        
        addChild(bottomRock)
        addChild(topRock)
        addChild(rockCollision)
        
        // 3. Use GameplayKit to generate random numbers in a range determining where the safe gap in rocks should be
        let xPosition = frame.width + topRock.frame.width
        
        let max = Int(frame.height / 3)
        let rng = GKRandomDistribution(lowestValue: -50, highestValue: max)
        let yPosition = CGFloat(rng.nextInt())
        
        // 4. Position rocks just off right edge of screen, animating them to the left edge.
        //    When off left edge, remove from scene
        let rockGap: CGFloat = 70 // the width of a gap between rocks player has to pass through
        
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockGap)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
        
        let endPosition = frame.width + (topRock.frame.width * 2)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision.run(moveSequence)
        
    }
    
    // Creates a sequence of rocks using createRocks() method continuously
    func startRocks() {
        // Action for creating a pair of rocks in scene
        let create = SKAction.run { [unowned self] in
            self.createRocks()
        }
        // Action for waiting between rock creation
        let wait = SKAction.wait(forDuration: 3)
        // Create a "create" -> "wait" sequence of actions...
        let sequence = SKAction.sequence([create, wait])
        // ... that will run indefinitely
        let repeatForever = SKAction.repeatForever(sequence)
        // And run!
        run(repeatForever)
    }
    
    // MARK: - SKScene methods
    override func didMove(to view: SKView) {
        // Use composed methods to build this up
        
        // 1. Create and animate player texture
        createPlayer()
        
        // 2. Create the background sky
        createSky()
        
        // 3. Create infinite scrolling background
        createBackground()
        
        // 4. Create infinitely scrolling ground
        createGround()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

}
