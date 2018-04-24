//
//  ResultsTableViewController.swift
//  WhatIsThatWhistle
//
//  Created by Ben Hall on 24/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import AVFoundation
import CloudKit

class ResultsTableViewController: UITableViewController {

    // MARK: - Properties
    var whistle: Whistle!
    var suggestions = [String]()
    var whistlePlayer: AVAudioPlayer!
    
    // MARK: - Selector methods
    @objc func downloadTapped() {
        // 1. Replace download button with activity spinner
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.tintColor = .black
        spinner.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        
        // 2. Ask CK to pull down full record for whistle
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: whistle.recordID) { [unowned self] record, error in
            // 3. If error occurs handle it and put download button back
            if let error = error {
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain,
                                                                        target: self, action: #selector(self.downloadTapped))
                    let ac = UIAlertController(title: "Error", message: "There was an error downloading this whistle; please try again later: \(error.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            } else { // successfully retrieved records
                // 4. If succesfully obtained record and audio for whistle, attach it to local whistle object
                if let record = record {
                    if let asset = record["audio"] as? CKAsset { // extract the audio asset
                        self.whistle.audio = asset.fileURL // associate this audio with VC instance Whistle object
                        
                        // 5. Create new navBarRightButton that says "Listen" and will call listenTapped selector method
                        DispatchQueue.main.async {
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Listen", style: .plain,
                                                                                     target: self, action: #selector(self.listenTapped))
                        }
                    }
                }
            }
        }
    }
    
    // Handles the playing of downloaded whistle audio asset
    @objc func listenTapped() {
        do {
            whistlePlayer = try AVAudioPlayer(contentsOf: whistle.audio)
            whistlePlayer.play()
        } catch {
            let ac = UIAlertController(title: "Playback failed", message: "There was an error playing back the audio to this whistle. Please try again: \(error.localizedDescription)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up navcontroller bar
        title = "Genre: \(whistle.genre!)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain,
                                                            target: self, action: #selector(downloadTapped))
        
        // Reguister dequeueable cells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Grab the suggestions from iCloud app storage for this whistle
        let reference = CKReference(recordID: whistle.recordID, action: .deleteSelf)
        let pred = NSPredicate(format: "owningWhistle == %@", reference) // checks for suggestions what have an owningWhistle entry that matches the reference
        let sort = NSSortDescriptor(key: "creationDate", ascending: true) // sort on creation date in ascending order
        let query = CKQuery(recordType: "Suggestions", predicate: pred) // We are querying the "Suggestions" record type on iCloud
        query.sortDescriptors = [sort]
        
        // Apply to container using convenience query methods (we want to access all entris of the Suggestions records)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { [unowned self] records, error in
            if let error = error { // error, alert user
                DispatchQueue.main.async { // main queue as this is a UI event
                    let ac = UIAlertController(title: "Error", message: "There was an error accessing this entry. Please try again later: \(error.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            } else {
                if let records = records {
                    self.parseResults(records: records)
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return suggestions.count + 1
        }
    }

    // We can set different headers for diff sections using this
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Suggested songs"
        }
        
        return nil
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue re-use cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // configure cell
        cell.selectionStyle = .none // most cells non-selectable
        cell.textLabel?.numberOfLines = 0 // multiple lines in comment allowed
        
        if indexPath.section == 0 {
            // This is the user submitted comments part
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            
            if whistle.comments.count == 0 {
                cell.textLabel?.text = "Comments: None"
            } else {
                cell.textLabel?.text = whistle.comments
            }
            
        } else {
            // This is the suggestions to the submitted tune
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            
            if indexPath.row == suggestions.count {
                // the is the final row, an add comments row that IS interactable
                cell.textLabel?.text = "Add suggestion..."
                cell.selectionStyle = .gray
            } else {
                // these are suggestion cells
                cell.textLabel?.text = suggestions[indexPath.row]
            }
        }
        
        // return cell
        return cell
    }

    // Handle the row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check tapped row was the second (1) section, and the final cell
        guard indexPath.section == 1 && indexPath.row == suggestions.count else { return }
        
        // Deselect the row (otherwise it will stay lookig like it's in selected state)
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Create alert controller waiting for input with textfield
        let ac = UIAlertController(title: "Suggest a song...", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] action in
            if let textField = ac.textFields?[0] {
                if textField.text!.count > 0 {
                    self.add(suggestion: textField.text!) // custom method to add input of textfield to suggestions
                }
            }
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    
    // MARK: - Instance methods
    // This is called when another user adds a suggestion to that the whistle may be.
    // A reference is made between the suggestion and the whistle it refers to.
    func add(suggestion: String) {
        // CKReference is what we will use here
        // This class requires the recordID that it needs to link to, and a behaviour to run when that linked record is deleted
        let whistleRecord = CKRecord(recordType: "Suggestions")
        let reference = CKReference(recordID: whistle.recordID, action: .deleteSelf) // upon Whistle record deletion, all child suggestions will also be deleted
        whistleRecord["text"] = suggestion as CKRecordValue
        whistleRecord["owningWhistle"] = reference as CKRecordValue // which whistle 'owns' this suggestion
        
        // Save this to iCloud app container
        CKContainer.default().publicCloudDatabase.save(whistleRecord) { [unowned self] record, error in
            DispatchQueue.main.async {
                if error == nil { // no errors yay!
                    self.suggestions.append(suggestion) // add the suggestions to the VC suggestions array
                    self.tableView.reloadData() // reload the VC tableView
                } else { // an error occurred in the upload. Communicate this through an alert controller
                    let ac = UIAlertController(title: "Error", message: "There was a problem submitting your suggestion: \(error!.localizedDescription)",
                        preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
        
        
    }
    
    // Parses "Suggestions" record type results fetched from iCloud backend for corresponding whistle
    func parseResults(records: [CKRecord]) {
        var newSuggestions = [String]() // a local variable of suggestions to edit so that we don't interfere with suggestions array on background threads
        
        for record in records {
            newSuggestions.append(record["text"] as! String)
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.suggestions = newSuggestions
            self.tableView.reloadData()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
