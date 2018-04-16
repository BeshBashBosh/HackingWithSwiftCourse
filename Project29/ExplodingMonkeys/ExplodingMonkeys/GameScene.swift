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
    

    
    override func didMove(to view: SKView) {

    }
    

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
