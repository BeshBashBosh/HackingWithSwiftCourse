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
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        addChild(player)
        
        // Animate the player texture
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        player.run(runForever)
    }
    
    // MARK: - SKScene methods
    override func didMove(to view: SKView) {
        // Use composed methods to build this up
        
        // 1. Create and animate player texture
        createPlayer()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

}
