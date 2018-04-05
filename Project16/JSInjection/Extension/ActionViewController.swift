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

    @IBOutlet var script: UITextView!
    
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
                    print(javaScriptValues)
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
