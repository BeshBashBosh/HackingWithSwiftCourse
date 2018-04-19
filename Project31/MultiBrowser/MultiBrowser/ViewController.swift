//
//  ViewController.swift
//  MultiBrowser
//
//  Created by Ben Hall on 19/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//


// NOTE: - WHEN ADDING A SUBVIEW TO A UISTACKVIEW, USE addArrangeSubview() NOT addSubview()
//         stack views have their own subviews that they arrange so subviews should instead be
//         added to the ArrangeSubview array to be managed separately to the stackviews native subviews

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    // MARK: - Properties
    weak var activeWebView: UIWebView? // Tracks which webview is currently active. Wesk so that it is deleted properly when user removes it
    
    // MARK: - Outlets
    @IBOutlet var textField: UITextField!
    @IBOutlet var stackView: UIStackView!
    
    // MARK: - Cutom Methods
    func setDefaultTitle() {
        title = "MultiBrowser"
    }
    
    func selectWebView(_ webView: UIWebView) {
        // Remove border from all but active webview in the stackview
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        
        // set the active webview
        activeWebView = webView
        webView.layer.borderWidth = 3 // Set a border around active webview
        
        // Update UI with new site
        updateUI(for: webView)
    }
   
    func updateUI(for webView: UIWebView) {
        title = webView.stringByEvaluatingJavaScript(from: "document.title") // set navbar title to that of website
        textField.text = webView.request?.url?.absoluteString ?? "" // set textfield to that of website
    }
    
    // MARK: - Selector methods
    @objc func addWebView() {
        let webView = UIWebView() // create a UIWebView
        webView.delegate = self // Delegate its communication to this VC (protocol added to class)
        stackView.addArrangedSubview(webView) // Add this webview to the stackview
        
        let url = URL(string: "https://www.hackingwithswift.com")! // Set a default url to load
        webView.loadRequest(URLRequest(url: url)) // Load the url into the webview
        
        webView.layer.borderColor = UIColor.blue.cgColor // Set the border color of webview to blue to show active state
        selectWebView(webView) // Custom function to present the border only on added webview (will become the active view)
        
        // MARK: - Gesture recognizer for selecting the active webview
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
        
    }
    
    @objc func deleteWebView() {
        // check if webview selected
        if let webView = activeWebView {
            // Find which of the stackview webviews this is
            if let index = stackView.arrangedSubviews.index(of: webView) {
                // remove from stackview
                stackView.removeArrangedSubview(webView)
                // remove webview from superview hierarchy
                webView.removeFromSuperview()
                
                // if no more webview exist set navbar title back to default
                if stackView.arrangedSubviews.count == 0 {
                    setDefaultTitle()
                } else {
                    // set webview following this as active webview
                    // if the index removed was at end of stackview, set to previous webview, else we can use the same index
                    // as removed webview
                    let currentIndex = (Int(index) == stackView.arrangedSubviews.count) ? stackView.arrangedSubviews.count - 1 : Int(index)
                    
                    // grab the webview at next index and set as active
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? UIWebView {
                        selectWebView(newSelectedWebView)
                    }
                }
            }
        }
    }
    
    // Change the active webview on tap of its view within the stackview
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? UIWebView {
            selectWebView(selectedWebView)
        }
    }
    
    // MARK: - Gesture recognizer delegate methods
    // This will tell all gestures to be handled together (i.e. our custom webview tap with all default webview gestures)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Textfield delegate methods
    // What to do when user presses return when in textview
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let webView = activeWebView, let address = textField.text { // unwrap the activeWebView (if it exists) and grab the address entered in the textfield
            if let url = URL(string: address) { // check this text is a url
                webView.loadRequest(URLRequest(url: url)) // load input url
                //title = textField.text
            } else { // alert invalid url
                let ac = UIAlertController(title: "Invalid URL", message: "Please enter a valid url", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        
        textField.resignFirstResponder() // get the textfield to vanish
        return true
    }
    
    // MARK: - WebView delegate methods
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView == activeWebView {
            updateUI(for: webView)
        }
    }
    
    // MARK: - Size Class methods
    // This watches for changes in the size class of the app. Manipulating this allows us to adjust the apps for better UI
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact { // if compact horizontal mode, stack webviews vertically (rows)
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal // otherwise stack them horizontally (columns)
        }
    }
    
    // MARK: - VC Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create navbar buttons to create and delete eventual webviews
        setDefaultTitle() // Customises nav bars title depending on selected webview
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let del = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [del, add]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

