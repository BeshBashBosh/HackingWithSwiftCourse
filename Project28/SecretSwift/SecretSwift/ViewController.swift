//
//  ViewController.swift
//  SecretSwift
//
//  Created by Ben Hall on 13/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
// Note: - KeychainWrapper.swift is a open-source (MIT license) class that make Keychain a lot easier
//         essentially making its operation similar to UserDefaults.

// TODO: - Add a fallback for if biometric id doesn't work (e.g. a password created in app and stored in the keychain)

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet var secret: UITextView!
    
    // MARK: - Actions
    @IBAction func authenticateTapped(_ sender: UIButton) {
        // MARK: - Code for Touch/Face-ID
        let context = LAContext() // part of Apple LocalAuthentication framework
        var error: NSError?
        
        // Find out if biometric authentication is available on the device
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!" // This is for touch-ID, face-ID reason is put in the plist under Privacy - Face ID Usage Description
            
            // Now evaluate the user for authentication
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] (success, authenticationError) in
                
                // This evaluation is not done on the main thread, so need to pass the outcome back
                DispatchQueue.main.async {
                    if success {
                        // bio-ID passed!
                        self.unlockSecretMessage()
                    } else {
                        // Error
                        let ac = UIAlertController(title: "Authentication Failed",
                                                   message: "You could not be verified; please try again.",
                                                   preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            print(error!.localizedDescription)
            // No biometry
        }
    }
    
    // MARK: Custom app methods
    // Unhides the textview and loads keychains text into it
    func unlockSecretMessage() {
        secret.isHidden = false // Unhide the text view
        title = "Secret stuff!" // Change the navController title
        
        // Extract any text saved in the keychain protexted storage
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text // and add it to the text view
        }
    }
    
    // Writes text input in the text view to keychain protected storage
    @objc func saveSecretMessage() {
        if !secret.isHidden { // check the text view is visible
            _ = KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
            secret.resignFirstResponder() // bye bye keyboard (done editing, this view is no longer the focus)
            secret.isHidden = true // hide the text view
            title = "Nothing to see here" // Change navController title
        }
    }
    
    
    // MARK: - Method to make text view adjust content and scroll insets when keyboard state changes
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            secret.contentInset = UIEdgeInsets.zero // No keyboard, full view screen
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
        
    }
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // MARK: - Code to make text view adjust content and scroll insets when keyboard state changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Give the navcontroller a title
        title = "Nothing to see here"
        
        // Watch for the app heading to background or multitasking mode. At that point, SAVE!
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage),
                                       name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

