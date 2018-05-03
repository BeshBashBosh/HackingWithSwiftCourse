//
//  ViewController.swift
//  UnitTest
//
//  Created by Ben Hall on 02/05/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    // MARK: - Properties
    var playData = PlayData()
    
    // MARK: - Default TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playData.allWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let word = playData.allWords[indexPath.row]
        cell.textLabel!.text = word
        
        // Add word count to detail label
        cell.detailTextLabel!.text = "\(playData.wordsCount.count(for: word))" // NSCountedSet method!
        
        return cell
    }
    
    
    // MARK: - Default VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "UnitTest"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

