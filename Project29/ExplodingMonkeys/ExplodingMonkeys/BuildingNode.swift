//
//  BuildingNode.swift
//  ExplodingMonkeys
//
//  Created by Ben Hall on 16/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class BuildingNode: SKSpriteNode {
    // NOTE: - We are not going to override the SKSpriteNode init() and we create these classes using
    //         those that exist already
    
    var currentImage: UIImage! // This will track the change in the nodes texture
    
    // This method sets up the SpriteNode by calling other class methods
    func setup() {
        // Give the node an identification name
        name = "building"
        // Render it as a UIImage
        currentImage = drawBuilding(size: size)
        // Set its texture
        texture = SKTexture(image: currentImage)
        // Configure the nodes hitbox and physics
        configurePhysics()
    }
    
    // This function sets up per-pixel physics for the SpriteNode's current texture
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size) // Create the hitbox for the building node
        physicsBody?.isDynamic = false // Building won't me moved by collisions
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue // building collision category
        physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue // can collide with bananas
    }
    
    // This fuction renders the building as an UIImage
    func drawBuilding(size: CGSize) -> UIImage {
        // 1. Create a new core graphics context at the size of the building
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            var color: UIColor
            
            // 2. Fill the context with a rectangle that's one of three colors
            switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
            case 0:
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
            
            // 3. Draw windows all over building in one of two colors - yellow (light on) or grey
            let lightOffColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOnColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
                for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
                    if RandomInt(min: 0, max: 1) == 0 {
                        ctx.cgContext.setFillColor(lightOnColor.cgColor)
                    } else {
                        ctx.cgContext.setFillColor(lightOffColor.cgColor)
                    }
                    ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }
        }

        
        // 4. Extract result as UIImage and return
        return img
    }
    
}
