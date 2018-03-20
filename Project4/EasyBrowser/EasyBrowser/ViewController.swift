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
    var progressView: UIProgressView!

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
    
    // MARK: - KVO Methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // What to do when observer noted a change in the progress of loading a page
        if keyPath == "estimatedProgress" {
            // Update the loading bar (progressView) with the webViews estimatedProgess
            progressView.progress = Float(webView.estimatedProgress)
        }
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
       
        // Create a progress bar for showing how much of page has loaded
        // Instantaite a UIProgressView with default styling
        progressView = UIProgressView(progressViewStyle: .default)
        // Set the progressView layout to take up as much space in its container as it can
        progressView.sizeToFit()
        // Wrap the progressView in a UIBarButtonItem for use in the navigationtoolbar
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // To watch for how much of a the page has loaded, need to speak with webView.estimatedProgess property
        // Whilst this property tells us how much has changed, it doesn't tell us WHEN it has changed.
        // To do this we use KVO (Key-Value Observing)
        // 1. Add an observer to some property with arguments specifying:
        // i. who is the observer, ii. what the property is we want to observe,
        // iii. which value we want (e.g. value just set or old value prior to change)
        // iv. a context that is used to identify which observer reported a change
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new, context: nil)
        // 2. In more complex KVO, should really also have a .removeObserver when done with the observations
        // 3. implement method for dealing with observerValue (above)
        
        // Create a tool bar spacer and refresh button
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        // Add spacer and refresh button to toolbar
        toolbarItems = [progressButton, spacer, refresh]
        // Make sure toolbar is shown
        navigationController?.isToolbarHidden = false
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

