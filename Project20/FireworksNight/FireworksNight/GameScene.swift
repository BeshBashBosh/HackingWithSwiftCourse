//
//  GameScene.swift
//  FireworksNight
//
//  Created by Ben Hall on 10/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    var gameTime: Timer! // A timer!
    var fireworks = [SKNode]() // An array to track the fireworks currently active in the scene
    
    // Limits of where fireworks can be launched from
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    // Track players score
    var score = 0 {
        didSet {
            // This will undoubtedly update a score node label
        }
    }
    
    // MARK: - Custom Methods
    // Creates firework node in scene
    // 3 inputs: horizontal movement speed (xMovement), horizontal (x) and vertical (y) spawn location
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        // 1a. Create Node to act as firework container
        let node = SKNode()
        // 1b. Position container node with inputs
        node.position = CGPoint(x: x, y: y)
        // 2a. Create rocket sprite node
        let firework = SKSpriteNode(imageNamed: "rocket")
        // 2b. Give rocket sprite node a name ("firework")
        firework.name = "firework"
        // 2c. Adjust its colorBlendFactor property so it can be coloured
        firework.colorBlendFactor = 1
        // 2d. Add to container node
        node.addChild(firework)
        // 3. Give firework sprite node a random colour from (cyan, green, or red)
        switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
        default:
            break
        }
        
        // 4.  Create UIBezierPath to represent firework movement
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        // 5. Tell container node to follow path described bt 4. (turning if neccessary)
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        // 6. Create particles behind the rocket
        let emitter = SKEmitterNode(fileNamed: "fuse")!
        emitter.position = CGPoint(x: 0, y: -22)
        node.addChild(emitter)
        
        // 7. Add firework to fireworks array and scene
        fireworks.append(node)
        addChild(node)
        
    }
    
    // Method to call createFirework() and launch one into scene
    @objc func launchFirework() {
        let movementAmount: CGFloat = 1800
        // Launch five fireworks at a time in four different shapes

        // USe RNG for a value between 0 ... 3
        switch GKRandomSource.sharedRandom().nextInt(upperBound: 4) {
        case 0:
            // 0 -> Launch firework straight up
            for xOffset in [0, -200, -100, 100, 200] { createFirework(xMovement: 0, x: 512 + xOffset, y: bottomEdge) }
        case 1:
            // 1 -> Fire in a fan from center outwards
            for xOffset in [0, -200, -100, 100, 200] {
                createFirework(xMovement: CGFloat(xOffset), x: 512 + xOffset, y: bottomEdge)
            }
        case 2:
            // 2 -> Fire left - right
            for yOffset in [400, 300, 200, 100, 0] {
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + yOffset)
            }
        case 3:
            // 3 -> Fire right - left
            for yOffset in [400, 300, 200, 100, 0] {
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + yOffset)
            }
        default:
            break
        }

        
    }
    
    // MARK: - SpriteKit methods
    override func didMove(to view: SKView) {
        // Add background node to the scene
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Create timer to launch fireworks every 6 seconds\
        gameTime = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFirework),
                                        userInfo: nil, repeats: true)
        
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
