//
//  GameScene.swift
//  Pachinko
//
//  Created by Ben Hall on 29/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
}
