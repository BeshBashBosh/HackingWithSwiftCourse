//
//  MyGenresViewController.swift
//  WhatIsThatWhistle
//
//  Created by Ben Hall on 24/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import CloudKit

class MyGenresViewController: UITableViewController {

    // MARK: - Properties
    var myGenres: [String]!
    
    // MARK: - VC Lifecycle MEthods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if user has already set the genres and restore if so, if not create empty array
        let defaults = UserDefaults.standard
        if let savedGenres = defaults.object(forKey: "myGenres") as? [String] {
            myGenres = savedGenres
        } else {
            myGenres = [String]()
        }

        // Navbar set-up
        title = "Notify me about..."
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain,
                                                            target: self, action: #selector(saveTapped))
        // Register re-use cell for tableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectGenreViewController.genres.count
    }

    // Define how cell is displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // get the genre of dequeued cell
        let genre = SelectGenreViewController.genres[indexPath.row]
        cell.textLabel?.text = genre
        
        // If users myGenres array contains this cell, add a checkmark to the cell
        if myGenres.contains(genre) {
            cell.accessoryType = .checkmark
        } else { // else no checkmark
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // Define what happens when cell tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the cell at the indexpath
        if let cell = tableView.cellForRow(at: indexPath) {
            let selectedGenre = SelectGenreViewController.genres[indexPath.row] // get the genre this cell corresponds to
            
            if cell.accessoryType == .none { // if no checkmark, add a checkmark and add to users list of genre specialities
                cell.accessoryType = .checkmark
                myGenres.append(selectedGenre)
            } else { // else remove from user's genre specialities
                cell.accessoryType = .none
                if let index = myGenres.index(of: selectedGenre) {
                    myGenres.remove(at: index)
                }
            }
        }
        // Deselect the view
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Instance Methods
    
    
    // MARK: - Selector Methods
    // Add user specialist genres to local storage and subscribe them to iCloud push notifications
    @objc func saveTapped() {
        let defaults = UserDefaults.standard
        defaults.set(myGenres, forKey: "myGenres")
        
        let database = CKContainer.default().publicCloudDatabase
        
        database.fetchAllSubscriptions { [unowned self] subscriptions, error in
            if error == nil {
                if let subscriptions = subscriptions {
                    
                    // Delete existing subscriptions to stop duplication errors
                    for subscription in subscriptions {
                        database.delete(withSubscriptionID: subscription.subscriptionID) { str, error in
                            if error != nil { // handle deletion error
                                DispatchQueue.main.async {
                                    let ac = UIAlertController(title: "Deletion Error", message: "There was an error deleting your notification subscription: \(error!.localizedDescription)", preferredStyle: .alert)
                                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                                    self.present(ac, animated: true)
                                }
                            }
                        }
                    }
                    
                    // Subscribe to CK push notifs for selected genres
                    for genre in self.myGenres {
                        let predicate = NSPredicate(format: "genre = %@", genre)
                        let subscription = CKQuerySubscription(recordType: "Whistles", predicate: predicate, options: .firesOnRecordCreation)
                        
                        let notification = CKNotificationInfo()
                        notification.alertBody = "There's a new whistle in the \(genre) genre"
                        notification.soundName = "default"
                        
                        subscription.notificationInfo = notification
 
                        database.save(subscription) { result, error in
                            if let error = error { // handle error
                                DispatchQueue.main.async {
                                    let ac = UIAlertController(title: "Subscription Error", message: "There was a problem signing up for notifications: \(error.localizedDescription)", preferredStyle: .alert)
                                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                                    self.present(ac, animated: true)
                                }
                            } 
                        }
                    }
                }
            } else { // handle error
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Fetch Error", message: "There was an error fetching your notification subscriptions: \(error!.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }


}
