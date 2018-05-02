//
//  ViewController.swift
//  GitHubCommit
//
//  Created by Ben Hall on 02/05/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    // MARK: - Properties
    var container: NSPersistentContainer! // manages connection to SQLite database
    
    // MARK: - Custom methods
    func createAlertWith(title: String?, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // MARK: - CoreData custom methods
    
    // Connects to persistent container and permanent storage
    private func connectToContainer() {
        // Create a persistent container for database with name of Core Data model file created
        self.container = NSPersistentContainer(name: "GHCommit")
        
        // Load saved database if exists, or create otherwise
        self.container.loadPersistentStores { [unowned self] (storeDescription, error) in
            if let error = error {
                self.createAlertWith(title: "DB Error.", message: "Could not connect to or create database. Please try again: \(error.localizedDescription)")
            }
        }
    }
    
    // Saves any changes to the database if they exist
    private func saveContext() {
        // Check the containers context to see if anything stored within it has changed
        if container.viewContext.hasChanges {
            do {
                // changes found, attempt to save these
                try container.viewContext.save()
            } catch {
                // error occurred in saving, alert!!!!
                self.createAlertWith(title: "DB Save Error",
                                     message: "There was an error in saving changes to the database: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Default VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up connection to database and its container
        self.connectToContainer()
        
        let commit = Commit()
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

