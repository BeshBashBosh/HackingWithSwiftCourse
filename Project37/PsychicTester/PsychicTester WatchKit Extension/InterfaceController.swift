//
//  InterfaceController.swift
//  PsychicTester WatchKit Extension
//
//  Created by Ben Hall on 30/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    // MARK: - Outlets
    @IBOutlet var welcomeText: WKInterfaceLabel!
    @IBOutlet var hideButton: WKInterfaceButton!
    
    // MARK: - Actions
    // Hides text and button
    @IBAction func hideWelcomeText() {
        welcomeText.setHidden(true)
        hideButton.setHidden(true)
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    // This is equivalent to viewDidLoad()...
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("WatchOS - willActivate()")
        // Create Watch Connectivity session matching the iOS app for communication between the two.
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("WatchOS - Session Activated")
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - Communication with iOS app methods
    // Will be called when message is received from iOS app
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        WKInterfaceDevice().play(.click)
    }
    
    // MARK: - WCSessionDelegate conformity stubs
    // needed for protocol conformity, but not going to use so left empty...
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

}
