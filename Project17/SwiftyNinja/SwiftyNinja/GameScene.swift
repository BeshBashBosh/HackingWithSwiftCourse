//
//  GameScene.swift
//  SwiftyNinja
//
//  Created by Ben Hall on 06/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

// MARK: - Custom Types
enum ForceBomb {
    case never, always, random
}

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    // MARK: - Properties
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSliceBG: SKShapeNode! // Background of user swipe node
    var activeSliceFG: SKShapeNode! // Foreground of user swipe node
    var activeSlicePoints = [CGPoint]() // Object to store the slice points
    
    var isSwooshSoundActive = false // Property for limiting number of swoosh sounds played at any one time
    var bombSoundEffect: AVAudioPlayer! // Sound effect for bomb's fuse
    
    var activeEnemies = [SKSpriteNode]() // Object to store enemies in scene
    
    // MARK: - Custom Methods
    // Creates socre label node
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.text = "Score: 0"
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
    }
    
    // Creates lives indicator node
    func createLives() {
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i*70)), y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode) // Append newly created node to lives array
        }
    }
    
    // Tracks all user interactions and draws lines where user is swiping/slicing
    // Will be one line atop another to give illusion of a glow
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 2
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = .white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    // Draw slice using Bezier path
    func redrawActiveSlices() {
        // Need three points to draw a line, if not clear shapes and exit
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        // If more than 12 slice points in slice array need to remove oldest one until at most 12 exist
        // This is purely to limit the length of the shown path
        while activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst() // Alternatively remove(at: 0)
        }
        
        // Start drawing line at start of first slice point, conitnuing through each slice point
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        // Update slice shape paths so they are drawn using their design (i.e. width+colour)
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    // Creates an enemey in the scene
    func createEnemy(forceBomb: ForceBomb = .random) {
        var enemy: SKSpriteNode
        // Randomly decide the enemy type from random number between 0 - 5 (0 is a bomb, will only happen 1/5 of the time)
        var enemyType = RandomInt(min: 0, max: 6)
        
        // Determine if method was called with specific bomb forcing conditions
        if forceBomb == .never {
            // We want an enemy
            enemyType = 1
        } else if forceBomb == .always {
            // We want a bomb
            enemyType = 0
        }
        
        if enemyType == 0 {
            // Create Bomb
            // 1. Create SpriteNode to hold bomb and fuse as children
            enemy = SKSpriteNode()
            
            // 2. set zposition to 1 (above enemies)
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            // 3. Create bomb image node, name it 'bomb' add to container
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            // 4. IF bomb fuse sound effect playing, stop and destroy it
            if bombSoundEffect != nil {
                bombSoundEffect.stop()
                bombSoundEffect = nil
            }
            
            // 5. Otherwise create new bomb fuse sound effect and play
            let path = Bundle.main.path(forResource: "sliceBombFuse.caf", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            let sound = try! AVAudioPlayer(contentsOf: url)
            bombSoundEffect = sound
            bombSoundEffect.play()
            
            // 6. Create particle emitter node for bomb fuse, position it at end of bombs fuse, add it to container.
            let emitter = SKEmitterNode(fileNamed: "sliceFuse")!
            emitter.position = CGPoint(x: 76, y: 64)
            enemy.addChild(emitter)
            
        } else {
            // Create Penguin
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }
        
        // Code to position enemies and their physics
        // 1. Give enemy random position at bottom of screen
        let randomPosition = CGPoint(x: RandomInt(min: 64, max: 960), y: -128)
        enemy.position = randomPosition
        
        // 2. Create random angular velocity (how fast enemy spins)
        let randomAngularVelocity = CGFloat(RandomInt(min: -6, max: 6)) / 2.0
        
        // 3. Create random X velocity (horizontal speed) taking into account enemy position
        var randomXVelocity = 0
        // Break horizontal scene into 4 equal sized columns
        if randomPosition.x < 256 {
            // 1st (leftmost) column
            randomXVelocity = RandomInt(min: 8, max: 15)
        } else if randomPosition.x < 512 {
            // 2nd (left-center) column
            randomXVelocity = RandomInt(min: 3, max: 5)
        } else if randomPosition.x < 768 {
            // 3rd (right-center) column
            randomXVelocity = RandomInt(min: 3, max: 5)
        } else {
            // 4th (rightmost) column
            randomXVelocity = RandomInt(min: 8, max: 15)
        }
        
        // 4. Create random Y velocity to make things fly at different speeds
        let randomYVelocity = RandomInt(min: 24, max: 32)
        
        // 5. Give enemies a circular physics bodt with collision bit mask of 0 (no collisions)
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        // Code for everything else
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    // Method for playing a swoosh sound
    func playSwooshSound() {
        // Set property specifying sound playing to true
        isSwooshSoundActive = true
        
        // Get a random value to pick one of the 3 swoosh sounds to play
        let randomNumber = RandomInt(min: 1, max: 3)
        // Get swoosh file name
        let soundName = "swoosh\(randomNumber).caf"
        
        // Play the swoosh sound
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        // Completion closure sets the sound active to false after sound has played. Above waitForCompletion param
        // when set to true lets spritekit know it needs to wait for completion (duh!)
        run(swooshSound) { [unowned self] in
            self.isSwooshSoundActive = false
        }
    }
    
    override func didMove(to view: SKView) {
        // Add background node to scene
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Add some physics to the scene
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        // Initialise the game with custom methods
        createScore() // Create score node
        createLives() // create no of lives node
        createSlices()

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Remove all existing points in activeSlicePoints array
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        // Get first touch location and add to newly empties activeSlicePoints
        if let touch = touches.first {
            let location = touch.location(in: self)
            activeSlicePoints.append(location)
            
            // Redraw the active slices
            redrawActiveSlices()
            
            // Remove actions currently attached to slice shapes (e.g. if they are currently in the middle of fading out)
            activeSliceBG.removeAllActions()
            activeSliceFG.removeAllActions()
            
            // Set alpha of slice shapes to be fully visible
            // (resets any fading out that may have happened during touchesEnded/Cancelled)
            activeSliceBG.alpha = 1
            activeSliceFG.alpha = 1
        }
 
    }
    
    // Called as user touch transitions across screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Figure out where in scene user touched.
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Add location to object storing this information
        activeSlicePoints.append(location)
        
        // Redraw the slice shape
        redrawActiveSlices()
        
        // Play 'swoosh' sound is it hasn't started
        if !isSwooshSoundActive {
            playSwooshSound()
        }
    }
    
    // Called when user stops touching scene
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Fade out slice shapes
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    // Called if user touch is interrupted by an event such as low battery warning
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Just calltouchesEnded
        touchesEnded(touches, with: event)
    }
    
    // This method is run before each frame is drawn. Is a good place to update the game state
    // Here we will stop the bomb fuse sound when none are on screen.
    override func update(_ currentTime: TimeInterval) {
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            // No bombs! - Stop the fuse sound!
            if bombSoundEffect != nil {
                bombSoundEffect.stop()
                bombSoundEffect = nil
            }
        }
    }

}
