//
//  ViewController.swift
//  GitHubCommit
//
//  Created by Ben Hall on 02/05/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    var container: NSPersistentContainer! // manages connection to SQLite database
    
    // ===============================================================================
    // REMOVED AS NSFectchedResultsControllerDelegate manages this now
    //var commits = [Commit]() // will store Commit objects extracted from CoreData DB
    // ===============================================================================
    
    var commitPredicate: NSPredicate? // Will allow us to filter our DB requests
    
    // property to optimize the entire fetch, storage, and UI sync processes
    var fetchedResultsController: NSFetchedResultsController<Commit>!
    
    // MARK: - Custom methods
    // Helper for creating alerts
    func createAlertWith(title: String?, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // Uses SwiftyJSON to parse data collected
    @objc private func fetchCommits() {
        // Get date of most recent retireved commits
        let newestCommitDate = getNewestCommitDate()
        
        // Grab data from online resource (GitHub API)
        if let data = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100&since=\(newestCommitDate)")!) {
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
        
        // Attach/create author for each Commit object
        var commitAuthor: Author!
        
        // Check if author for commit already exists
        let authorRequest = Author.createFetchRequest() // create fetch request
        authorRequest.predicate = NSPredicate(format: "name == %@", json["commit"]["committer"]["name"].stringValue)
        
        if let authors = try? container.viewContext.fetch(authorRequest) {
            if authors.count > 0 {
                // BONZA! WE ALREADY HAVE THIS AUTHOR!
                commitAuthor = authors[0]
            }
        }
        
        // Check to see if commitAuthor is still nil
        if commitAuthor == nil {
            // No author found - Create them!
            let author = Author(context: container.viewContext)
            author.name = json["commit"]["committer"]["name"].stringValue
            author.email = json["commit"]["committer"]["email"].stringValue
            commitAuthor = author
        }
        
        // Set the author, either saved or new
        commit.author = commitAuthor
    }
    
    // Creates request to database and fetches results
    private func loadSavedData() {
        
        // If no NSFetchedResultsController exists yet...
        if fetchedResultsController == nil {
            // Create Commit managed object fetch request
            let request = Commit.createFetchRequest()
            // Apply sorting description
            //let sort = NSSortDescriptor(key: "date", ascending: false)
            let sort = NSSortDescriptor(key: "author.name", ascending: true) // use NSFetchedResultsController options for section title headers and cells arranged by author name!
            request.sortDescriptors = [sort]
            // Only fetch in batches of 20 at a time
            request.fetchBatchSize = 20
            
            // Instantiate the NSFetchedResultsController with this fetch request type
            // and the GHCommit container context
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: container.viewContext,
                                                                  sectionNameKeyPath: "author.name", cacheName: nil)
            // Set NSFetchedResultsControllerDelegate to this VC
            fetchedResultsController.delegate = self
        }
        
        // Apple the predicate filter
        fetchedResultsController.fetchRequest.predicate = commitPredicate
        
        // Attempt fetch request
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            //Error in fetching, present alert to user
            self.createAlertWith(title: "DB Fetch Error", message: "There was an error fetching from the database. \(error.localizedDescription)")
        }
        
        //==========================================================
        // PRE NSFetchedResultsController Implementation
        //==========================================================
//        // Create a fetch request from the database object type
//        let request = Commit.createFetchRequest()
//        // Describe how to sort fetched results (by date descending)
//        let sort = NSSortDescriptor(key: "date", ascending: false)
//        // Add sort options to request
//        request.sortDescriptors = [sort]
//        // Add filtering predicate to the request
//        request.predicate = commitPredicate
//
//        do {
//            // Attempt fetch request
//            self.commits = try container.viewContext.fetch(request)
//            print("Got \(commits.count) commits")
//            // Reload the tableView with results if it worked and should have returned array of results
//            tableView.reloadData()
//        } catch {
//            // Error in fetching, present alert to user
//            self.createAlertWith(title: "DB Fetch Error", message: "There was an error fetching from the database. \(error.localizedDescription)")
//        }
        
    }

    // Change predicate filter on fetched request results
    @objc func changeFilter() {
        let ac = UIAlertController(title: "Filter commits...", message: nil, preferredStyle: .actionSheet)
        
        // 1 - Fixes only
        // NOTE: "message CONTAINS[c] 'thing'" is like == but searches message for whether it contains thing.
        //       [c] is predicate-speak for CASE-INSENSITIVE
        ac.addAction(UIAlertAction(title: "Show only fixes", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'")
            self.loadSavedData()
        })
        
        // 2 - Begins with...
        ac.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
            self.loadSavedData()
        })
        
        // 3 - Filter by date
        ac.addAction(UIAlertAction(title: "Show only recent", style: .default) { [unowned self] _ in
            let twelveHoursAgo = Date().addingTimeInterval(-43200)
            self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo as NSDate)
            self.loadSavedData()
        })
        
        // 4 - Show only commits by particular author (Durian - Joe Groff an Apple Swift Engineer) using commit-author entity relationship
        ac.addAction(UIAlertAction(title: "Show only Durian commits", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "author.name == 'Joe Groff'")
            self.loadSavedData()
        })
        
        // 5 - Default no filter
        ac.addAction(UIAlertAction(title: "Show all commits", style: .default) { [unowned self] _ in
            self.commitPredicate = nil
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // Extract the date of the last retrieved commit (if any exist) or return date in past to retrieve all commits
    private func getNewestCommitDate() -> String {
        let formatter = ISO8601DateFormatter() // create instance of dateformatter (ISO8601)
        
        // Create fetch request on Commit managed object
        let newest = Commit.createFetchRequest()
        // sort request by date in descending order (i.e. newest first)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        newest.sortDescriptors = [sort]
        // get only the first result
        newest.fetchLimit = 1
        
        // Attempt fetch request
        if let commits = try? container.viewContext.fetch(newest) {
            // If commit found extract the timestamp + 1s as a string
            if commits.count > 0 {
                return formatter.string(from: commits[0].date.addingTimeInterval(1))
            }
        }
        
        // Otherwise set the date as some point in the past
        return formatter.string(from: Date(timeIntervalSince1970: 0))
    }
    
    // MARK: - Default VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Filter nav bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))
        
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
        //return 1
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return commits.count
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
        
        //let commit = commits[indexPath.row]
        let commit = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = commit.message
        cell.detailTextLabel!.text = "By \(commit.author.name) on \(commit.date.description)"
        
        return cell
    }
    
    // Pass control to DetailViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.detailItem = fetchedResultsController.object(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Commit insertion or deletion of row by user
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let commit = commits[indexPath.row] // extract the Commit object
            let commit = fetchedResultsController.object(at: indexPath)
            container.viewContext.delete(commit) // delete from the GHCommit container context
            
            // The NSFetchedResultsViewController is clever and has knowledge of the state of the viewContext.
            // so when something is removed from it, it acts to update the UI!
            // NOTE - WE DO HAVE TO IMPLEMENT SUCH A METHOD... (see below)
            
            //commits.remove(at: indexPath.row) // remove from VC instance parameter array
            //tableView.deleteRows(at: [indexPath], with: .fade) // delete from tableView
            self.saveContext() // save to context
        }
    }
    
    // Setting title for section headers
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // This will set section header for each commit authors name!
        return fetchedResultsController.sections![section].name
    }
    
    // MARK: - NSFetchedResultsViewController methods
    // When object changes, this gets called by the NSFetchedResultsVC
    // This method is called from anywhere! For example, if we deleted the object from the DetailViewController
    // it would still update. THE DATA DRIVES THE VIEW RATHER THAN VIEW DRIVES THE DATA
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }

}

