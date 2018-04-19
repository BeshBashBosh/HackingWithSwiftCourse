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
    
    // MARK: - Actions
    
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
            } else { // alert invalid url
                let ac = UIAlertController(title: "Invalid URL", message: "Please enter a valid url", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        
        textField.resignFirstResponder() // get the textfield to vanish
        return true
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

