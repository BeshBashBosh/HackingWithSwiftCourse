//
//  ViewController.swift
//  WhiteHouse
//
//  Created by Ben Hall on 22/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    // MARK: - Properties
    var petitions = [[String: String]]() // An array of dictionaries
    
    // MARK: - tableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Dequeuing cell at position \(indexPath.row)")
        let petition = petitions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petition["title"]
        cell.detailTextLabel?.text = petition["body"] // The detail label text of the proto cell
        return cell
    }
    
    // Loading a detail view that hasn't been created in the storyboard
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Methods
    // Parse JSON
    func parse(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            let obj = ["title": title, "body": body, "sigs": sigs]
            petitions.append(obj)
        }
        tableView.reloadData()
    }
    
    // Error messages if processing link to JSON fails
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Assign url string of JSON file
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        // Try to convert above url string into a URL object - that is, check URL is valid
        if let url = URL(string: urlString) {
            // Try to get contents of url
            if let data = try? String(contentsOf: url) {
                // Use SwiftyJSON to parse the json data into dictionaries
                let json = JSON(parseJSON: data)
                
                // Check the status of the JSON file (response code: 200)
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    print("Good to go!")
                    parse(json: json)
                    return
                }
            }
        }
        
        showError()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

