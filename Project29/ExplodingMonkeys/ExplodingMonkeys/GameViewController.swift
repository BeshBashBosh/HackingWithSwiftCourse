//
//  GameViewController.swift
//  ExplodingMonkeys
//
//  Created by Ben Hall on 16/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    // MARK: - GameScene delegation
    var currentGame: GameScene!
    
    // MARK: - UI Outlets
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    
    // MARK: - UI Actions
    @IBAction func angleChanged(_ sender: UISlider) {
    }
    @IBAction func velocityChanged(_ sender: UISlider) {
    }
    @IBAction func launch(_ sender: UIButton) {
    }
    
    // MARK: - VC Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                // Now create hard-link to the GameScene in this VC
                currentGame = scene as! GameScene
                currentGame.viewController = self // This was create in the GameScene.swift as a weak property to avoid strong ref cycle (i.e. GVC keeps GS alive but not vice versa).
                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
