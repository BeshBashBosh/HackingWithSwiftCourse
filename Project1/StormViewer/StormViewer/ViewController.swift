//
//  ViewController.swift
//  StormViewer
//
//  Created by Ben Hall on 19/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit // This is the toolkit for iOS User Interface

class ViewController: UITableViewController {

    // Create collection to store the paths to picture files
    var pictures = [String]()

    // MARK: Set Up TableView
    
    // Set the number of rows in each section of the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Set the number of rows to the number of pictures we have
        return pictures.count
    }
    
    // Set up prototype cell, i.e. what the cell looks like
    // iOS only shows so many table cells at a time. Instead of loading ALL
    // cells in a table it will 'dequeue' a cell when it leaves the screen
    // and reuse the cell for any new elements about to appear.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Grab a reusable cell from the recycled cell list
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        // Fill this cells text the path of the picture file
        cell.textLabel?.text = pictures[indexPath.row]
        
        // Return the cell that has been set up
        return cell
    }
    
    // Instantiate the detail screen on cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Try to case instantiated VC as a DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // If worked can access the detailVC properties
            // Set the detailVC selectedImage property to the imagePath to load
            vc.selectedImage = pictures[indexPath.row]
            // Load the detailVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create an instance of the file manager
        let fm = FileManager.default
        // Create a link to the system path we want to investigate
        let path = Bundle.main.resourcePath!
        // Try to get list of items within above path
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // Loop through items found to find particular files
        for item in items {
            if item.hasPrefix("nssl") {
                // Add nssl image path to pictures colleciton
                pictures.append(item)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

