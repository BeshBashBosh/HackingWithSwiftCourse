//
//  ViewController.swift
//  NamesToFaces
//
//  Created by Ben Hall on 23/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

// TODO: - 1. AlertController when picture tapped to ask whether to delete or not
// TODO: - 2. Take an image (picker.sourceType = .camera) instead of selecting from photos (only works on device)
// can check if such a source type is available with UIImagePickerController.isSourceTypeAvailable
// TODO: - 3. Need to reload cells already added!
// Currently they are stored on disk. This is actually fixed in Project 12 UserDefaults

import UIKit

// Note: conformance to ImagePicker and NavController delegate for use with UIImagePickerController
// Note: When asking for access to photolibrary need to modify the plist appropriately
class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    var people = [Person]()
    
    // MARK: - CollectionView Set up
    // Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue cell protoype and cast as custom PersonCell type
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        
        // Get person from people array
        let person = people[indexPath.row]
        
        // Set name label of cell to person's name
        cell.name.text = person.name
        
        // create UIImage from person's image filename
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        // Edit cell+contents style
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    // cell taps
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get person assigned to cell
        let person = people[indexPath.item]
        
        // Create alert controller with text field for name entry, ok, and cancel button
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            person.name = newName.text!
            
            self.collectionView?.reloadData()
        })
 
        // Then present it
        present(ac, animated: true)
        
    }
    
    // MARK: - Selector methods
    // Naviagation bar add person action to access photo library
    @objc func addNewPerson() {
        // Access the imagepicker
        let picker = UIImagePickerController()
        // Allow editing so user can do stuff like cropping
        //picker.sourceType = .camera
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

