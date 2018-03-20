//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Ben Hall on 20/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Variables, Constants, Views
    // Create property reference to a web view
    var webView: WKWebView!

    // MARK: Outlets
    
    // MARK: Actions
    
    // MARK: - Methods
    private func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    // MARK: - Selector Methods
    @objc func openTapped() {
        // Create ubstabce if alert action sheet
        let ac = UIAlertController(title: "Open page...", message: nil,
                                   preferredStyle: .actionSheet)
        // add actions (opening a website from list)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        // add cancel action
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Anchor the actionSheet to the bar button item pressed (for iPad)
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        // present the actionSheet
        present(ac, animated: true)
    }
    
    // MARK: load overrides
    // loadView is called before viewDidLoad. We can put this code below anywhere
    // but logically layed out code is nice code.
    // By overriding the default implementation of loadView (which loads from the storyboard)
    // we are forcing our code to load from our own specified code for views!
    override func loadView() {
        // Create instance of WKWebView
        webView = WKWebView()
        // Delegation programming pattern. Allows us to be informed about changes
        // for example, by setting the navigationDelegate of the the webView to self, we can be notified
        // in THIS VC if a page change occurs in the WebView. Implementing any of the delegates methods will
        // override their default behaviour to do what we want!
        webView.navigationDelegate = self
        // Make the root view (can also be written self.view) of this VC the above webView
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // create a URL - in this example directing to a webpage
        let url = URL(string: "https://www.hackingwithswift.com")!
        // Create a URL load request and pass that to the webView to load
        webView.load(URLRequest(url: url))
        // Enable swiping for back/forward page navigation in the web view
        webView.allowsBackForwardNavigationGestures = true
        
        // Give user option to select a website by pressing a navigation bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain,
                                                            target: self, action: #selector(openTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

