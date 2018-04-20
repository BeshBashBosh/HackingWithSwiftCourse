//
//  ViewController.swift
//  SwiftSearcher
//
//  Created by Ben Hall on 19/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
// TODO: - Convert projects array to hold bustom subclass rather than just array (i.e. a Project class/struct)
// TODO: - Right-click on NSAttributedStringKey.font -> Jump to Definition, then check out other NSAttributes that can be manipulated.
// TODO: - Handle user changing their Dynamic Type Size (subscribe to UIContentSizeCategoryDidChange notification in NotificationCenter to check for this change whilst app in use and handle it by refreshing UI).


import UIKit
// SafariWebViews
import SafariServices
// Spotlight integration
import CoreSpotlight // heavy lifting for indexing items in spotlight
import MobileCoreServices // for identifying what type of data we want to store

class ViewController: UITableViewController {

    // MARK: - Properties
    var projects = [[String]]() // stores the details on the HwS projects presented int eh TableView
    var favorites = [Int]() // Stores which HwS projects have been favorited by user
    
    // MARK: - CustomMethods
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        // Create NSAtrribute arrays for title and subtitle string
        let titleAttributes = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .headline),
                               NSAttributedStringKey.foregroundColor: UIColor.purple]
        let subtitleAttributes = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        // Create title and subtitle NSStrings using these attributes
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSMutableAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        // Join these attribute strings together and return
        titleString.append(subtitleString)
        return titleString
    }
    
    // Will present the HwS tutorial for each project in TableView cells within an SFSafariViewController
    func showTutorial(_ which: Int) {
        if let url = URL(string: "https://www.hackingwithswift.com/read/\(which + 1)") {
            let config = SFSafariViewController.Configuration() // set-up configuration of SFSafariVC
            config.entersReaderIfAvailable = true // Enable Reader mode
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    // MARK: - Custom methods for Spotlight integration
    // Looks inside projects to find project info to index in spotlight
    func index(item: Int) {
        let project = projects[item] // get the project
        
        // Set the attribute set for the spotlight index
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = project[0]
        attributeSet.contentDescription = project[1]
        
        // Create the spotlight index item from this attribute set
        let item = CSSearchableItem(uniqueIdentifier: "\(item)", domainIdentifier: "com.beshbashbosh",
                                    attributeSet: attributeSet)
        // indexed items are stored for about a month. Can extend this (difficult to test) using:
        item.expirationDate = Date.distantFuture
        // Index the item! Trailiing closure to report error...
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed!")
            }
        }
    }
    
    // Removes indexed items from spotlight search
    func deindex(item: Int) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"]) { error in
            if let error = error {
                print("Deindexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully removed!")
            }
        }
    }
    
    // MARK: - TableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) // dequeue cell
        let project = projects[indexPath.row] // grab project at cell index
        //cell.textLabel?.text = "\(project[0]): \(project[1])" // set cells text to project
        cell.textLabel?.attributedText = makeAttributedString(title: project[0], subtitle: project[1])
        
        // Add a favorites check mark if it exists in saved storage
        if favorites.contains(indexPath.row) {
            cell.editingAccessoryType = .checkmark
        } else {
            cell.editingAccessoryType = .none
        }
        
        return cell // return cell
    }
    
    // cell tapped, do something!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTutorial(indexPath.row)
    }
    
    // Inform the tableview which rows should have an "insert" or "delete" icon
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if favorites.contains(indexPath.row) {
            return .delete // remove favorite
        } else {
            return .insert // add favorite
        }
    }
    
    // Method tells table what to do when user clicks insert or delete icon on each row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Switch on the editingStyle to determine whether adding or removing favorite
        switch editingStyle {
        case .delete:
            if let index = favorites.index(of: indexPath.row) {
                favorites.remove(at: index)
                deindex(item: indexPath.row)
            }
        case .insert:
            favorites.append(indexPath.row)
            index(item: indexPath.row)
        default:
            return
        }
        
        // Save the new favorites to user defaults
        let defaults = UserDefaults.standard
        defaults.set(favorites, forKey: "favorites")
        
        // Reload the tableview at editing row (no need to reload entire thing!)
        tableView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    // MARK: - VC Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add projects to projects array
        projects.append(["Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"])
        projects.append(["Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"])
        projects.append(["Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"])
        projects.append(["Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"])
        projects.append(["Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"])
        projects.append(["Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"])
        projects.append(["Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"])
        projects.append(["Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."])
        
        // Load favorited projects (if any yet) from UserDefaults
        let defaults = UserDefaults.standard
        if let savedFavorites = defaults.object(forKey: "favorites") as? [Int] {
            favorites = savedFavorites
        }
        
        // Put tableview in editing mode
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true // Allows us to still select an entry when in edit mode
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  
    }


}

