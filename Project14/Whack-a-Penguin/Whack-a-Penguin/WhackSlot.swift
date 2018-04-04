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
    
    // Function to add a hole at some input position
    func configure(at position: CGPoint) {
        self.position = position // SKNode's init has a position property that is being modified here
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }

}
