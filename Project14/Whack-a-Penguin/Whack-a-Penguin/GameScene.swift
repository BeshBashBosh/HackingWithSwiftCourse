//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by Ben Hall on 04/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    // MARK: - Properties
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        // Set the background
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Game score label
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    

}
