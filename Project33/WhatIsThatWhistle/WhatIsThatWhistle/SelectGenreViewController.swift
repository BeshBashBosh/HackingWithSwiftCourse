//
//  SelectGenreViewController.swift
//  WhatIsThatWhistle
//
//  Created by Ben Hall on 23/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class SelectGenreViewController: UITableViewController {

    // MARK: - Properties
    static var genres = ["Unknown", "Blues", "Classical", "Electronic", "Jazz",
                         "Metal", "Pop", "Reggae", "RnB", "Rock", "Soul"]
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navbar title
        title = "Select genre..."
        // Add a back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Genre", style: .plain, target: nil, action: nil)
        // Regiseter a cell identifier ("Cell") for reuse
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) // dequeue the cell
        cell.textLabel?.text = SelectGenreViewController.genres[indexPath.row] // set the text
        cell.accessoryType = .disclosureIndicator // Add an accessory to interact with
        return cell // return the cell
    }
    
    // When genre selected, pass this over to the AddComments VC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) { // Grab the cell tapped
            let genre = cell.textLabel?.text ?? SelectGenreViewController.genres[0] // grab the genre of cell tapped
            let vc = AddCommentsViewController() // instantiate a AddCommentsVC
            vc.genre = genre // set the AddCommentsVC genre property to the genre label extracted from the cell
            navigationController?.pushViewController(vc, animated: true) // push the AddCommentsVC to the user.
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
