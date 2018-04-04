//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Ben Hall on 04/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    
    // MARK: - Properties
    var charNode: SKSpriteNode! // A property to store a penguin node
    
    // Function to add a hole at some input position
    func configure(at position: CGPoint) {
        self.position = position // SKNode's init has a position property that is being modified here
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        // Create a cropNode slightly higher than hole position
        // This will be used for masking a penguin, ultimately giving illusion of it appearing from the hole
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        // Position the cropNode in front of other nodes (zPosition -1 for background, 0 default)
        cropNode.zPosition = 1
        // Note: Check out the whackMask.png file for what the cropnode looks like.
        // With such a mask, anything within a coloured region of the mask will be visible.
        // Anything within a transparent region will be invisible.
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        // The below commented out text shows exactly where the cropmask will be placed in the scene
//        let test = SKSpriteNode(imageNamed: "whackMask")
//        test.position = CGPoint(x: 0, y: 15)
//        test.zPosition = 1
//        addChild(test)
        
        // Create a good penguin node
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        // Start way below the hole
        charNode.position = CGPoint(x: 0, y: -90)
        // Give the node a name
        charNode.name = "character"
        // Add this node to the cropNode
        cropNode.addChild(charNode)
        
        // Add the cropBode to the scene
        addChild(cropNode)
    }

}
