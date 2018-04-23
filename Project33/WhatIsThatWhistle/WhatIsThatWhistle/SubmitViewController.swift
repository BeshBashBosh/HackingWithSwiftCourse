//
//  SubmitViewController.swift
//  WhatIsThatWhistle
//
//  Created by Ben Hall on 23/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import CloudKit

class SubmitViewController: UIViewController {

    // MARK: - Properties
    var genre: String!
    var comments: String!
    
    // MARK: - Outlets
    var stackView: UIStackView!
    var status: UILabel!
    var spinner: UIActivityIndicatorView!
    
    // MARK: - Actions
    @objc func doneTapped() {
        // Once upload complete user click will return to the top level VC in the navcontroller (ViewController)
        _ = navigationController?.popToRootViewController(animated: true) // this method actually returns an array of the popped VCs, but we don't need them here
    }
    
    // MARK: - VC Lifecycle methods
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .gray // set background color to grey
        
        // Create ad setup Stackview
        stackView = UIStackView()
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackViewDistribution.fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        // Set stakview constraints
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Create and set-up UILabel
        status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Submitting..."
        status.textColor = .white
        status.font = UIFont.preferredFont(forTextStyle: .title1)
        status.numberOfLines = 0
        status.textAlignment = .center
        
        // Create and set-up activity spinner
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        // Add views to stackviews
        stackView.addArrangedSubview(status)
        stackView.addArrangedSubview(spinner)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "You're all set!" // set navbar title
        navigationItem.hidesBackButton = true // hide the back button to stop user from backing out until upload complete
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Once view has appeared fully, do the submission/upload to iCloud
        doSubmission()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    func doSubmission() {
        // 1. Create record to send to iCloud
        let whistleRecord = CKRecord(recordType: "Whistles") // Create "record" to store values (most types) and assets (binary blobs)
        whistleRecord["genre"] = genre as CKRecordValue // store genre metadata
        whistleRecord["comments"] = comments as CKRecordValue // store comments metadata
        
        let audioURL = RecordWhistleViewController.getWhistleURL() // Get the URL of the audio recording
        let whistleAsset = CKAsset(fileURL: audioURL) // create binary asset of this file
        whistleRecord["audio"] = whistleAsset // add key-value pair for this asset
        
        // 2. Handle the result of submission
        CKContainer.default().publicCloudDatabase.save(whistleRecord) { [unowned self] record, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.status.text = "Error \(error.localizedDescription)"
                    self.spinner.stopAnimating()
                } else {
                    self.view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
                    self.status.text = "Done!"
                    self.spinner.stopAnimating()
                    
                    ViewController.isDirty = true
                }
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain,
                                                                         target: self, action: #selector(self.doneTapped))
            }
        }
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
