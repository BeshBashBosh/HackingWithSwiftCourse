//
//  GameScene.swift
//  MarbleMaze
//
//  Created by Ben Hall on 12/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // MARK: - Game methods
    // This long function handles loading a level and all nodes within it
    func loadLevel() {
        // Get the text file that describes the level layout
        if let levelPath = Bundle.main.path(forResource: "level1", ofType: "txt") {
            // Try and read the entire contents of file to memory
            if let levelString = try? String(contentsOfFile: levelPath) {
                // Break this into an array of each new line
                let lines = levelString.components(separatedBy: "\n")
                // Loop through each line of file to determine the layout of nodes in each row
                // (reversed to fill in from bototm to top
                for (row, line) in lines.reversed().enumerated() {
                    // and loop through each line for layout of nodes in row
                    for (column, letter) in line.enumerated() {
                        // Set the position of where the node will be drawn
                        // each node will be 64x64points
                        let position = CGPoint(x: (column * 64) + 32, y: (64 * row) + 32)
                        
                        // Now get drawing the nodes
                        if letter == "x" {
                            // draw wall
                        } else if letter == "v" {
                            // draw vortex
                        } else if letter == "s" {
                            // draw star
                        } else if letter == "f" {
                            // draw the finish
                        }
                        
                        
                    }
                }
                
            }
        }
    }
    
    override func didMove(to view: SKView) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
