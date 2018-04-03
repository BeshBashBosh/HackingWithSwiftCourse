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
        
        // Adda 'hitbox' physics body to the frame of the scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    // This method is called in both UI and SpriteKit wenever someone starts touching the device screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Find out where the screen was touched
        if let touch = touches.first {
            // Get the location of the touch
            let location = touch.location(in: self)
            // Create a red box with size 64x64 points
            let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))
            // Add physics to the box with 'hitbox' same size as the box
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
            // Set the boxes centre position to that of the touch
            box.position = location
            // Add the box to the scene
            addChild(box)
        }
    }
    
}
