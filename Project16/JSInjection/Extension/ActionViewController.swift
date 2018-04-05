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
