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
        angleLabel.text = "Angle: \(Int(angleSlider.value))°" // shift+alt+8 for degree symbol
    }
    @IBAction func velocityChanged(_ sender: UISlider) {
        velocityLabel.text = "Velocity \(Int(velocitySlider.value))"
    }
    
    // Launches a banana and hides interface so it cannot be used until turn finished
    @IBAction func launch(_ sender: UIButton) {
        // Hide interface
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        launchButton.isHidden = true
        playerNumber.isHidden = true
        
        // Launch banana!
        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    // MARK: - Game methods
    func activatePlayer(number: Int) {
        // Set the player number
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        // Enable UI
        playerNumber.isHidden = false
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        launchButton.isHidden = false
        
    }
    
    
    // MARK: - VC Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update UI
        angleChanged(angleSlider)
        velocityChanged(velocitySlider)
        
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
