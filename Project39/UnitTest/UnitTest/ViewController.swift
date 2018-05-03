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
    
    // MARK: - Selector Methods
    @objc func searchTapped() {
        let ac = UIAlertController(title: "Filter...", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Filter", style: .default) { [unowned self] _ in
            let userInput = ac.textFields?[0].text ?? "0"
            self.playData.applyUserFilter(userInput)
            self.tableView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    // MARK: - Default TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playData.filteredWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let word = playData.filteredWords[indexPath.row]
        cell.textLabel!.text = word
        
        // Add word count to detail label
        cell.detailTextLabel!.text = "\(playData.wordsCount.count(for: word))" // NSCountedSet method!
        
        return cell
    }
    
    // MARK: - Default VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "UnitTest"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self,
                                                            action: #selector(searchTapped))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

