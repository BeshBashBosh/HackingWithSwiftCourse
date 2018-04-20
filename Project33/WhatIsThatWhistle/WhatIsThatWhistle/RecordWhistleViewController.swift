//
//  RecordWhistleViewController.swift
//  WhatIsThatWhistle
//
//  Created by Ben Hall on 20/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class RecordWhistleViewController: UIViewController {

    // MARK: - Properties
    var stackView: UIStackView!
    
    // MARK: - VC Lifecycle methods
    // Do all view loading in code
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .gray // set color of main view
        
        // Create the stackview
        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        // Constraints for stackview
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
