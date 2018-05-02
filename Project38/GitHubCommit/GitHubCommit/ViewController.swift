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
    var commits = [Commit]() // will store Commit objects extracted from CoreData DB.
    
    // MARK: - Custom methods
    // Helper for creating alerts
    func createAlertWith(title: String?, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // Uses SwiftyJSON to parse data collected
    @objc private func fetchCommits() {
        // Grab data from online resource (GitHub API)
        if let data = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100")!) {
            // Parse the data received into JSON
            let jsonCommits = JSON(parseJSON: data)
            // Parse this JSON into an array of JSON entries for counting how many entries accessed
            let jsonCommitArray = jsonCommits.arrayValue
            
            print("Received \(jsonCommitArray.count) new commits.")
            
            // Above done on background thread, now we want to dispatch UI stuff back to main thread
            DispatchQueue.main.async { [unowned self] in
                for jsonCommit in jsonCommitArray {
                    // create a Commit entry to the data within the GHCommit data model container
                    let commit = Commit(context: self.container.viewContext)
                    // Pass to custom function that parses the JSON into the Commit instance
                    self.configure(commit: commit, usingJSON: jsonCommit)
                }
                
                // Save any changes to database should they exist
                self.saveContext()
                
                // Load results in tableView
                self.loadSavedData()
            }
        }
    }
    
    // MARK: - CoreData custom methods
    // Connects to persistent container and permanent storage
    private func connectToContainer() {
        // Create a persistent container for database with name of Core Data model file created
        self.container = NSPersistentContainer(name: "GHCommit")
        
        // Load saved database if exists, or create otherwise
        self.container.loadPersistentStores { [unowned self] (storeDescription, error) in
            // set the policy for merging duplicate entries allowinf Core Data to allow updates on objects
            // e.g. in this app, if two objects exists with different messages but the same sha entry,
            // the database (stored version) is overwritted by the newly obtained (in-memory) version.
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
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
    
    // Parses JSON object into Commit instance
    private func configure(commit: Commit, usingJSON json: JSON) {
        // Extract simple string types
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["html_url"].stringValue
        
        // Parse the Date() entry
        let formatter = ISO8601DateFormatter()
        commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()
    }
    
    // Creates request to database and fetches results
    private func loadSavedData() {
        // Create a fetch request from the database object type
        let request = Commit.createFetchRequest()
        // Describe how to sort fetched results (by date descending)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        // Add sort options to request
        request.sortDescriptors = [sort]
        
        do {
            // Attempt fetch request
            self.commits = try container.viewContext.fetch(request)
            print("Got \(commits.count) commits")
            // Reload the tableView with results if it worked and should have returned array of results
            tableView.reloadData()
        } catch {
            // Error in fetching, present alert to user
            self.createAlertWith(title: "DB Fetch Error", message: "There was an error fetching from the database. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Default VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up connection to database and its container
        self.connectToContainer()
        
        // Fetch GitHub commits to be added to database and do so in the backrgound!
        performSelector(inBackground: #selector(fetchCommits), with: nil)

        // Load saved data from DB and present in VC
        self.loadSavedData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Default TableVC methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
        
        let commit = commits[indexPath.row]
        cell.textLabel!.text = commit.message
        cell.detailTextLabel!.text = commit.date.description
        
        return cell
    }
    
    
    

}

