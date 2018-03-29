//
//  ViewController.swift
//  NamesToFaces
//
//  Created by Ben Hall on 23/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

// Note: conformance to ImagePicker and NavController delegate for use with UIImagePickerController
// Note: When asking for access to photolibrary need to modify the plist appropriately
class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    var people = [Person]()
    
    // MARK: - CollectionView Set up
    // Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue cell protoype and cast as custom PersonCell type
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        return cell
    }
    
    // MARK: - Selector methods
    // Naviagation bar add person action to access photo library
    @objc func addNewPerson() {
        // Access the imagepicker
        let picker = UIImagePickerController()
        // Allow editing so user can do stuff like cropping
        picker.allowsEditing = true
        // Set thus VC as the delegate for the picker
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    // MARK:- Delegate conformance methods
    // UIImagePicker "optional" methods (that aren't really optional if you want to do anything with the picker...)
    // Deal with user having selected an image from photolibrary
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 1. Extract image from passed in dictionary
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {return}
        // 2. Generate unique filename for image (UUID - Universally Unique Identifier)
        let imageName = UUID().uuidString // generate UUID
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName) // Append to app's documents folderpath
        // 3. Convert to JPEG, write to disk
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            try? jpegData.write(to: imagePath) // this is a Data object
        }
        
        // Implementation of Person custom class
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView?.reloadData()
        
        // 4. Dismiss picker view controller
        dismiss(animated: true)
    }
    
    // MARK: - Custom methods
    // Getting the apps document directory
    func getDocumentsDirectory() -> URL {
        // Get the app's document directory relative to user's home location
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Extract first elements which *should* be user's home directory
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // MARK: - load methds
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add a navigation button to add photos
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                           action: #selector(addNewPerson))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

