//
//  CardViewController.swift
//  PsychicTester
//
//  Created by Ben Hall on 30/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    // MARK: - Instance Properties
    weak var delegate: ViewController! // delegate to ViewContoller so we can communicate info back
    
    var front: UIImageView! // image for front of card
    var back: UIImageView! // image of back of card
    
    var isCorrect = false // bool for whether card is correct or not
    
    // MARK: - objc methods
    // Pushes a card tap from here to the delegate VC (which must also have a cardTapped() method
    @objc func cardTapped() {
        delegate.cardTapped(self)
    }
    
    // Animate card to shrink and dissapear
    @objc func wasntTapped() {
        UIView.animate(withDuration: 0.7) {
            self.view.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
            self.view.alpha = 0
        }
    }
    
    // Animate card to flip over, with back of card becoming hidden, and front being shown
    @objc func wasTapped() {
        UIView.transition(with: view, duration: 0.7, options: [.transitionFlipFromRight],
                          animations: { [unowned self] in
                            self.back.isHidden = true
                            self.front.isHidden = false
        })
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set size of view
        view.bounds = CGRect(x: 0, y: 0, width: 100, height: 140)
        
        // Create two imageviews for back and front of the card
        // NOTE: Setting the image view to an image will give it dimensions automagically (set to image dims)
        back = UIImageView(image: UIImage(named: "cardBack"))
        front = UIImageView(image: UIImage(named: "cardBack"))
        
        // Add imageviews to the view as subviews
        view.addSubview(back)
        view.addSubview(front)
        
        // Hide the front of card as default
        front.isHidden = true
        // set back of card opacity to 0
        back.alpha = 0
        
        // Animate the back into view for some nice flair
        UIView.animate(withDuration: 0.2) {
            self.back.alpha = 1
        }
        
        
        // Set up a TapGestrureRecgonizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped)) // set-up a tap gesture
        back.isUserInteractionEnabled = true // enable user interaction to back of card
        back.addGestureRecognizer(tap) // add gesture recognizer to back of card
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
