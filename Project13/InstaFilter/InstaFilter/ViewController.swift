//
//  ViewController.swift
//  InstaFilter
//
//  Created by Ben Hall on 04/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    
    // MARK: - Properties
    var currentImage: UIImage!
    
    // CoreImage props
    var context: CIContext!
    var currentFilter: CIFilter!
    
    // MARK: - Actions
    @IBAction func changeFilter(_ sender: UIButton) {
    }
    
    
    @IBAction func save(_ sender: UIButton) {
    }
    
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        applyProcessing()
    }
    
    // MARK: - UIImagePicker Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image // Copy of the image manipulate with CI
        
        // CoreImage manipulation
        // Create a CIImage from a UIImage
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        
    }
    
    // MARK: - CoreImage Methods
    func applyProcessing() {
        // Assign the sliders 'intensity' to control the filters intensity
        currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        // Create a CGImage from the output of the currentFilter, this command actually does the CI processing
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            // Recreate a UIImage of the processed image
            let processedImage = UIImage(cgImage: cgimg)
            // Set this processed image to the image view
            imageView.image = processedImage
        }
    }
    
    // MARK: - Selector Methods
    // Image picker
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Load methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add button to nav bar to allow adding image to UIImageView
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(importPicture))
        
        // CoreImage
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

