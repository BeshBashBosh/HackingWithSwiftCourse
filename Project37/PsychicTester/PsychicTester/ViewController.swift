//
//  ViewController.swift
//  PsychicTester
//
//  Created by Ben Hall on 30/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    // MARK: - Instance properties
    var allCards = [CardViewController]()
    
    // MARK: - Outlets
    @IBOutlet var cardContainer: UIView!
    
    // MARK: -  Instance methods
    
    // Removes any existing cards from this VC
    private func removeCards() {
        for card in allCards {
            card.view.removeFromSuperview() // remove from the superview ( cardContainer <UIView> )
            card.removeFromParentViewController() // remove reference to parent VC (self)
        }
        
        allCards.removeAll(keepingCapacity: true) // remove any CardViewControllers from the allCards property
        
    }
    
    // Adds Cards to UIView container of this VC
    private func addCard(with image: UIImage, at position: CGPoint, correctCard: UIImage) {

        // 1. Creat new card
        let card = CardViewController()
        // 1a. Set delegate for new CardViewController() to this VC for communication
        card.delegate = self
        
        // 2. View controller containment methods that adds the card's view to the cardContainer UIView
        addChildViewController(card) // Adds CardVC as a child of self
        cardContainer.addSubview(card.view) // Adds CardVC.view as subview to our UIView container
        card.didMove(toParentViewController: self) // Registers the movement (i.e. rotation etc.) to the motion of the parent VC, that is keeps them in sync!
        
        // 3. Position card appropriately and set it's front card image
        card.view.center = position
        card.front.image = image
        
        // 4. Note which card is the star for cheating ;)
        if card.front.image == correctCard {
            card.isCorrect = true
        }
        
        // 5. Add new CardVC to self array of CardVCs
        allCards.append(card)
    }
    
    // MARK: - objc methods
    @objc func loadCards() {
        
        // Remove any existing cards
        self.removeCards()
        
        // Set the positions of the cards
        let cardPositions = [
            CGPoint(x: 75, y: 85),
            CGPoint(x: 185, y: 85),
            CGPoint(x: 295, y: 85),
            CGPoint(x: 405, y: 85),
            CGPoint(x: 75, y: 235),
            CGPoint(x: 185, y: 235),
            CGPoint(x: 295, y: 235),
            CGPoint(x: 405, y: 235)
        ]
        
        // Load the front image of the Zener cards
        let circle = UIImage(named: "cardCircle")!
        let cross = UIImage(named: "cardCross")!
        let lines = UIImage(named: "cardLines")!
        let square = UIImage(named: "cardSquare")!
        let star = UIImage(named: "cardStar")!
        
        // create an array of these images to be shuffled
        var images = [circle, circle, cross, cross, lines, lines, square, star]
        images = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: images) as! [UIImage]
        
        // Loop over images, creating a CardViewController for each one and referencing wrt this ViewContoller
        for (index, position) in cardPositions.enumerated() {
            self.addCard(with: images[index], at: position, correctCard: star)
        }

        
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Generate and load the Zener cards
        self.loadCards()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

