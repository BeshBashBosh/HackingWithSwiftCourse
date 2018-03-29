//
//  Person.swift
//  NamesToFaces
//
//  Created by Ben Hall on 29/03/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class Person: NSObject {

    // MARK: Properties
    var name: String
    var image: String
    
    // MARK: Initialisers
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
}
