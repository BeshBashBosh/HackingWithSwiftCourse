//
//  GameScene.swift
//  Pachinko
//
//  Created by Ben Hall on 29/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
 
    // Create an inelastic object for bouncy balls to hit
    func makeBouncer(at position: CGPoint) {
        // Create the bouncer
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        // Set the position
        bouncer.position = position
        // Give the bouncer a hitbox
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        // Make it inelastic
        bouncer.physicsBody?.isDynamic = false
        // Add it to the scene
        addChild(bouncer)

    }
    
    // Creates visual representation of where user needs to aim
    func makeSlot(at position: CGPoint, isGood: Bool) {
        // initialise nodes for the slot base and visual flair (glow)
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        // Determine if good or bad slot
        if isGood {
            // Create the nodes from images
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            // Add a name to the node to keep track of it
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        // Set the positions of the nodes within the scene
        slotBase.position = position
        slotGlow.position = position
        
        // Add physics hitbox to the slot
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        // Add the nodes to the scene
        addChild(slotBase)
        addChild(slotGlow)
        
        // Add rotating action to slots glow
        // Create the spinning action (rotate through 180deg over 10secs
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        // Wrap in another SKAction to repeat the spinning 'forever'
        let spinForever = SKAction.repeatForever(spin)
        // Run the action on the desired scene nodes
        slotGlow.run(spinForever)
    }
    
    override func didMove(to view: SKView) {
        
        // Make this scene the delegate to the "physics world's" contact delegate
        physicsWorld.contactDelegate = self
        
        // Add a background
        // Create the background from an image file
        let background = SKSpriteNode(imageNamed: "background.jpg")
        // Set the centre position of the background node
        background.position = CGPoint(x: 512, y: 384)
        // Set the blend mode to one that basically just means "just draw it"
        background.blendMode = .replace
        // Set this background to a zPosition truly in the background
        background.zPosition = -1
        // Add this node as a child to the scene
        addChild(background)
        
        // Add a 'hitbox' physics body to the frame of the scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // Create slots
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        // Create bouncers
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))

    }
    
    // This method is called in both UI and SpriteKit wenever someone starts touching the device screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Find out where the screen was touched
        if let touch = touches.first {
            // Get the location of the touch
            let location = touch.location(in: self)
            
            
            // BOUNCY BALLS
            // Create ball from image asset
            let ball = SKSpriteNode(imageNamed: "ballRed")
            // Set the hit box size of the ball
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            
            // collisionBitMask - What nodes should a node bump into (default: everything)
            // contactTestBitMask - What collisions between nodes should be reported (default: nothing)
            // Set it so that all ball collisions with other nodes will be reported.
            // NOTE: We still need to determine the answers to
            // whether the ball touched the slot or slot touched the ball, for example.
            ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
            
            // Set how bouncy the ball is
            ball.physicsBody?.restitution = 0.4
            // Set position of ball to touch event location
            ball.position = location
            // Add name to ball to keep track of it
            ball.name = "ball"
            // Add the ball to the scene
            addChild(ball)
            
            
            // BOXES
            
//            // Create a red box with size 64x64 points
//            let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))
//            // Add physics to the box with 'hitbox' same size as the box
//            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
//            // Set the boxes centre position to that of the touch
//            box.position = location
//            // Add the box to the scene
//            addChild(box)
        }
    }
    
}
