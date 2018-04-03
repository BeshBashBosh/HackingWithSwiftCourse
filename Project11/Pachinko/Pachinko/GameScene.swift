//
//  GameScene.swift
//  Pachinko
//
//  Created by Ben Hall on 29/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
// TODO: - Generate random number to select a different image for balls (there are several coloured ones)
// TODO: - Give limit on no of balls in game.
// TODO: - Remove obstacles as they are hit (can the game be cleared with only n balls?). Green slot could give extra ball
// TODO: - Clicking on obstacle box also removes it.


import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
 
    // Score tracking properties
    var scoreLabel: SKLabelNode! // This is like a UILabel for SpriteKit
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
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
    
    // Function for tracking what a ball node collides with
    func collisionBetween(ball: SKNode, object: SKNode) {
        // Since we are interrogating the objects name as good or bad, we are ignoring cases of ball-ball collisions
        if object.name == "good" {
            destroy(ball: ball)
            // Increment score
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            // Decrement score
            score -= 1
        }
    }
    
    // Function for removing the balls from play
    func destroy(ball: SKNode) {
        // SPECIAL FX!!!!!!
        // SKEmitterNode is a powerful class for high-performance particle effects
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    // Physics contact checking method
    // This deals with whether the ball contacted a slot, or slot contacted a node question
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Guard check nodes exist and clean exit if one doesn't.
        // This is important if a contact is reported of nodeA contacted nodeB AND nodeB contacted nodeA
        // If this isn't caught, the second of thhese contact reports will result in a crash as the ball would
        // have already been removed!
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
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
        
        // Create score label and add flair
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        
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
            
            // Determine what nodes were touched
            let object = nodes(at: location)
            
            if object.contains(editLabel) {
                // Edit label touched, toggle edit state
                editingMode = !editingMode
            } else {
                // Add random blocks if in edit mode, otherwise add ball
                if editingMode {
                    // EDIT MODE
                    // This uses the provided Helper.swift file to generate random colours
                    // Create a random size (uses GamePlayKit)
                    let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(),
                                      height: 16)
                    // Create a box node
                    let box = SKSpriteNode(color: RandomColor(), size: size)
                    // Random rotation of box
                    box.zRotation = RandomCGFloat(min: 0, max: 3)
                    // Set location to touch location
                    box.position = location
                    // Give it a hitbox
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    // Make it inelastic
                    box.physicsBody?.isDynamic = false
                    // Add to scene
                    addChild(box)
                } else {
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
                    // Set position of ball to touch event location - forced to near top of screen
                    ball.position = CGPoint(x: location.x, y: 700)
                    // Add name to ball to keep track of it
                    ball.name = "ball"
                    // Add the ball to the scene
                    addChild(ball)
                }
            }
            
            

            
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
