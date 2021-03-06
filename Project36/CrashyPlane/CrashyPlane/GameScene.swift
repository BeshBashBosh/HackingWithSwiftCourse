//
//  GameScene.swift
//  CrashyPlane
//
//  Created by Ben Hall on 27/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
// TODO: - Solve multiple scoring occurring when avoiding obstacles (per-pixel multiple contacts registering?) - FIXED
// TODO: - Scale of scene changing when new game starts?
// TODO: - Implement new obstacles (trees?, moving obstacles?)
// TODO: - Difficulty ramping up over time (e.g. gap getting smaller, more obstacles, gravity increasing?)
// TODO: - Secondary scoring system (e.g. passing through hoops?)
// TODO: - Universal support (e.g. iPad?)

import SpriteKit
import GameplayKit

enum GameState {
    case showingLogo
    case playing
    case dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Instance Properties
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }

    
    var backgroundMusic: SKAudioNode!
    
    // Game state properties
    var logo: SKSpriteNode!
    var gameOver: SKSpriteNode!
    var gameState = GameState.showingLogo
    
    // MARK: - Composed Methods
    
    // Adds a player to the scene
    func createPlayer() {
        // Create the player node from initial texture
        let playerTexture = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 5, y: frame.height * 0.75)
        player.name = "player"
        addChild(player)
        
        // Add some contact physics
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size()) // "pixel-perfect" collision hitbox
        player.physicsBody?.contactTestBitMask = player.physicsBody!.collisionBitMask //The player can collide with anything (the default for collisionBitMask), so tell us when that happens
        player.physicsBody?.isDynamic = false // BEN HALL - changed for sake of gameState. Will be reactivated once game started
        player.physicsBody?.collisionBitMask = 0 // this will make the player bounce off NOTHING. So player can report that it contacts with anything, but won't actually collide with anything. We only want the former.s
        player.physicsBody?.usesPreciseCollisionDetection = true
        
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
            
            // Add some physics hitbox to ground
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false
            
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
        // Add some physics to sprite
        bottomRock.physicsBody = SKPhysicsBody(texture: bottomRock.texture!, size: bottomRock.texture!.size())
        bottomRock.physicsBody?.isDynamic = false
        // and some positioning/scaling
        bottomRock.zPosition = -20 // behind the ground sprites
        
        let topRock = SKSpriteNode(texture: rockTexture)
        // Add some physics to sprite
        topRock.physicsBody = SKPhysicsBody(texture: topRock.texture!, size: topRock.texture!.size())
        topRock.physicsBody?.isDynamic = false
        // and some positioning/scaling
        topRock.zPosition = -20
        topRock.zRotation = .pi
        topRock.xScale = -1.0 // normally this scales the node horizontally. Here, a value of -1 inverts it!
        
        // 2. Create large red rectangle, positioned just after rocks, will track if player has succesfully passed through
        //    obstacle unscathed. Essentially, touch rectangle, score a point!
        let rockCollision = SKSpriteNode(color: .clear, size: CGSize(width: 32, height: frame.height))
        rockCollision.name = "scoreDetect"
        // Add some physics to sprite
        rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
        rockCollision.physicsBody?.isDynamic = false
        
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
        let rockGap: CGFloat = 150//70 // the width of a gap between rocks player has to pass through
        
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
    
    // Create score label node
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        
        addChild(scoreLabel)
    }
    
    // Create background music
    func startBGM() {
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
    
    // Create Gamelogos
    func createLogos() {
        logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logo)
        
        gameOver = SKSpriteNode(imageNamed: "gameover")
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.alpha = 0
        addChild(gameOver)
    }
    
    // MARK: - SKScene methods
    override func didMove(to view: SKView) {
        // CREATE THE PHYSICS!!
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
        
        // Create some background music!
        startBGM()
        
        // Create logos to be used by the gamestate
        createLogos()
        
        // Use composed methods to build this up
        
        // 1. Create and animate player texture
        createPlayer()
        
        // 2. Create the background sky
        createSky()
        
        // 3. Create infinite scrolling background
        createBackground()
        
        // 4. Create infinitely scrolling ground
        createGround()
        
        // 5. Create rock obstacles to be avoided
        //startRocks() // BEN HALL - Moved to take into account gameState. Called once game has actually started
        
        // 6. Create a score label
        createScore()
        
        
        
    }
    
    // How to handle collisions
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node

        guard bodyA?.parent != nil && bodyB?.parent != nil else { return }
        
        if bodyA?.name == "scoreDetect" || bodyB?.name == "scoreDetect" {
            if bodyA == player {
                bodyB?.removeFromParent()
            } else {
                bodyA?.removeFromParent()
            }
            
            let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
            run(sound)
            score += 1
            return
            
        }
        
        // If we got to this point, the player has collided with a bad area, that means game over!
        if bodyA == player || bodyB == player {
            // Create an explosion
            if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            
            // Play explosion sound
            let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
            run(sound)
            
            // Proceed gameState to .dead
            gameOver.alpha = 1 // make gameOver node opaque
            gameState = .dead
            backgroundMusic.run(SKAction.stop()) // Stop background music
            
            // Remove player from game
            player.removeFromParent()
            // Halt the game
            speed = 0
        }
    }
    
    // Respond to user touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .showingLogo:
            gameState = .playing // change the state to playing mode
            
            // Fadeout logo, wait, activate the player physics and generation of obstacles, remove logo
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let wait = SKAction.wait(forDuration: 0.5)
            let activatePlayer = SKAction.run { [unowned self] in
                self.player.physicsBody?.isDynamic = true
                self.startRocks()
            }
            let remove = SKAction.removeFromParent()
            
            // Run above sequence of events
            let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
            logo.run(sequence)
            
        case .playing:
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0) // remove any existing upward velocity when player touches screen and applying...
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20)) // every time player touches screen, give it a shove upwards
            
        case .dead:
            // Create a fresh new gamescene!
            let scene = GameScene(fileNamed: "GameScene")!
            let transition = SKTransition.moveIn(with: .right, duration: 1)
            self.view?.presentScene(scene, transition: transition)
        }
        

        
        
    }
    
    // Any custom logic to do each frame of the game?
    override func update(_ currentTime: TimeInterval) {
        // Upon instantiating a new game scene from .dead gameState in touchesBegan, this method may be called before didMove(to:) which
        // instantiates the player sprite. guard here until player exists!
        guard player != nil else { return }
        
        // Apply a small rotation to plane based on vertical velocity to give a nice bit of visual flare
        let rotation = player.physicsBody!.velocity.dy * 0.001 // rotation based on 1000th of player vertical velocity
        let rotate = SKAction.rotate(byAngle: rotation, duration: 0.1) // happening at sub frame rate so will appear to be continuosly happening
        player.run(rotate)
    }

}
