//
//  Person.swift
//  NamesToFaces
//
//  Created by Ben Hall on 29/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

// NOTE: - NSObject is required when conforming to NSCoding
class Person: NSObject, NSCoding {
    
    // MARK: NSCoder stubs
    // This is used when saving an object of this class
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
    
    // Required means that anything that subclasses this must implement this method
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        image = aDecoder.decodeObject(forKey: "image") as! String
    }
    

    // MARK: Properties
    var name: String
    var image: String
    
    // MARK: Initialisers
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    
}
