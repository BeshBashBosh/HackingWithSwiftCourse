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
    var isVisible = false // Tracks if penguin is visiable and can be hit
    var isHit = false // Tracks if penguin has been hit already
    
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
    
    // Method for showing and activating a penguin from a slot
    func show(hideTime: Double) {
        // If penguin is already visible quick exit the method
        if isVisible { return }
        
        // Set the scale of the character to default
        charNode.xScale = 1
        charNode.yScale = 1
        
        // Create an action to move the penguin character over a duration of 0.05 sec
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        // Set the penguin node visibility to true
        isVisible = true
        // Set the penguin's hit status to false
        isHit = false
        
        // Only show a good penguin (positive points) 1/3 of the time, otherwise bad penguin
        if RandomInt(min: 0, max: 2) == 0 {
            // Use SKTexture to change the appearance of the penguin character node
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        // Hide enemy after period of time
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [unowned self] in
            self.hide()
        }
    }
    
    // Method to hide an enemy/penguin
    func hide() {
        // Quick exit if enemy isn't visible
        if !isVisible { return }
        
        // Move enemy back into hole
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        // Make it no longer visible and interactable
        isVisible = false
    }
    
    
    // Method for tracking and dealing with a user 'hit' on the penguin
    func hit() {
        // Record the penguin is hit
        isHit = true
        
        // Set up sequence of events for when penguin is hit
        // Wait for 0.25 sec (so user knows they hit it)
        let delay = SKAction.wait(forDuration: 0.25)
        // Hide the penguin by moving it back into the hole
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        // Set the visible flag for the penguin to false so it can no longer be interacted with
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        // Run the above sequence of events
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }

}
