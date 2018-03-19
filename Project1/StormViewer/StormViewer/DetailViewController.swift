//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Ben Hall on 19/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // Create an outlet to the IB UIImageView
    @IBOutlet var imageView: UIImageView!
    
    
    // Create a variable to store the path of the selected image to be loaded
    var selectedImage: String? // Optional as it won't exist when the VC is first created
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
