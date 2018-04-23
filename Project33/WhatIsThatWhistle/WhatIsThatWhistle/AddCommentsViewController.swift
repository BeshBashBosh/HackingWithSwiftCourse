//
//  AddCommentsViewController.swift
//  WhatIsThatWhistle
//
//  Created by Ben Hall on 23/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class AddCommentsViewController: UIViewController, UITextViewDelegate {

    // MARK: - Properties
    var genre: String!
    let placeholder = "If you have any additional comments that might help identify your tune, enter them here!"
    
    // MARK: - Outlets
    var comments: UITextView!
    
    // MARK: - Actions
    @objc func submitTapped() {
        let vc = SubmitViewController() // instantiate the next vc in the stack - the cloudkit enabled submitVC
        vc.genre = genre // pass along the genre property
        
        // pass along the comments (if any...)
        if comments.text == placeholder {
            vc.comments = ""
        } else {
            vc.comments = comments.text
        }
        // push new vc to user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - VC Lifecycle Methods
    
    // Set up the barebones VC
    override func loadView() {
        super.loadView()
        
        comments = UITextView() // instantiate the text view
        comments.translatesAutoresizingMaskIntoConstraints = false // we will define the constrains
        comments.delegate = self // Set this vc as the delegate to receive text from the text view
        comments.font = UIFont.preferredFont(forTextStyle: .body) // set our preferred font
        view.addSubview(comments) // add the view to the VC
        
        // Set up constraints
        comments.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        comments.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        comments.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        comments.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Comments..." // navbar title
        // a done bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitTapped))
        comments.text = placeholder // placeholder text for the textview
        
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
