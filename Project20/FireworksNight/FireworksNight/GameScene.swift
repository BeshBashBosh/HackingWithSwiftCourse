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
    func createFirework() {
        
    }
    
    // Method to call createFirework() and launch one into scene
    @objc func launchFirework() {
        
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
