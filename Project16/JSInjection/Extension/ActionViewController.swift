//
//  ActionViewController.swift
//  Extension
//
//  Created by Ben Hall on 05/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var script: UITextView!
    
    // MARK: - Properties
    var pageTitle = ""
    var pageURL = ""
    
    // MARK: - Selector Methods
    // Await a notification that the keyboard has appeared or changed state and adjust textview to accomodate it
    @objc func adjustForKeyboard(notification: Notification) {
        // Extract values from natification
        let userInfo = notification.userInfo!
        // Get frame of keyboard after it has been drawn, converting to a CGRect
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // Convert frame coords to view coords
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        // Set insets of textview
        if notification.name == Notification.Name.UIKeyboardWillHide {
            script.contentInset = UIEdgeInsets.zero // This is for when hardware keyboards are connected
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        // Add scroll indicators within inset
        script.scrollIndicatorInsets = script.contentInset
        // Adjust textview to range shown in scrolled window after keyboard appeared/state changed
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // The bolierplate code apple offers essentially does the below but looping through all items
        // and providers to find the first image it can. That is, the apple extension is configured by default
        // to deal with images (not web page content as in this app extension).
        
        // extensionContext lets us control how an extension interacts with the parent app
        // inputItems is an array of data the parent app sends to the extension to use
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            // The inputItem will be an array of 'attachments' which are NSItemProviders
            if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                // loadItem asks the itemProvider to actually provide us with its item
                // This acts asynchronously through the completion closure.
                // It will keep executing while the item provider is busy loading and sending its data
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [unowned self] (dict, error) in
                    // the loadItem will provide two parameters to the closure
                    // a dictionary provided by the item provider and any error that may have occurred
                    let itemDictionary = dict as! NSDictionary
                    let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
                   
                    // Associate this data with class properties
                    self.pageTitle = javaScriptValues["title"] as! String
                    self.pageURL = javaScriptValues["URL"] as! String
                    
                    // Set nav bar title to the page title (use GCD)
                    DispatchQueue.main.async {
                        self.title = self.pageTitle
                    }
                    
                }
            }
        }
        
        // Add navigation bar item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                                            action: #selector(done))
        
        // Implementation of observers on keyboard state change so that text entered in the textfield will
        // not dissapear under the keyboard
        // Add observers to watch keyboard state changes via the NotificationCenter
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: .UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: .UIKeyboardWillChangeFrame, object: nil)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Pass back text entered into textfield by user
        let item = NSExtensionItem() // Create NSExtensionItem to host items
        let argument: NSDictionary = ["customJavaScript": script.text] // Create NSDict to store custom JS
        // ^^ and put this into another dictionary with extension related key
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        // ^^ Then wrap this dictionary in an NSItemProbider object
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        // And pass this as an attachment
        item.attachments = [customJavaScript]
        
        // return the NSExtensionItem
        self.extensionContext!.completeRequest(returningItems: [item])
        
        // This is then sent back to safari and appear in the finalize() part of Action.js to be processed
    }

}
