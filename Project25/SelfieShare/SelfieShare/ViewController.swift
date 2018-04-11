//
//  ViewController.swift
//  SelfieShare
//
//  Created by Ben Hall on 11/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Properties
    var images = [UIImage]() // Storage for images
    
    // MARK: - Custom Methods
    
    // MARK: - Selector Methods
    // Grabs the image picker
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // This will prompt user to decide how they want to connect to peers over network
    @objc func showConnectionPrompt() {
        return
    }
    // MARK: - CollectionView methods
    // Number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // Dequeuing cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        // Access the imageview within the cell
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    // MARK: - UIImagePicker delegate methods
    // Called when image picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the picked image
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        // Dismiss the picker
        dismiss(animated: true)
        
        // Add to images array
        images.insert(image, at: 0)
        
        // Reload collection view
        collectionView?.reloadData()
    }
    
    // MARK: - VC methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Edit nav controller title
        title = "SelfieShare"
        
        // Add right bar button item showing camera item and links to selector method importPicture
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self,
                                                            action: #selector(importPicture))
        // Add left bar button item showing add button that links to selector showConnectionPrompt
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                           action: #selector(showConnectionPrompt))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

