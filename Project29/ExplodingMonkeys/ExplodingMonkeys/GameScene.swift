//
//  GameScene.swift
//  ExplodingMonkeys
//
//  Created by Ben Hall on 16/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit
import GameplayKit

// Enum for collision bitmask groups
enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene {
    
    // MARK: - VC delegation
    weak var viewController: GameViewController!
    
    // MARK: - Properties
    var buildings = [BuildingNode]()
    
    // MARK: - Set-up methods
    func createBuildings() {
        // add buildings to scene spaced horizontally starting slighlty off screen (x: -15) up until far edge
        // give 2 point gap between buildings
        
        // Buildings will be randome size.
        // Height -> 300 - 600
        // Width -> Divide evenly by 40 (for window drawing) (gen no. between 2 ... 4 and x40)
        
        var currentX: CGFloat = -15
        while currentX < 1024 {
            let size = CGSize(width: RandomInt(min: 2, max: 4) * 40,
                              height: RandomInt(min: 300, max: 600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    // MARK: - Game methods
    func launch(angle: Int, velocity: Int) {
        
    }
    
    // MARK: - SK lifecycle methods
    override func didMove(to view: SKView) {
        // Create a background
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        // Create buildings
        createBuildings()
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
