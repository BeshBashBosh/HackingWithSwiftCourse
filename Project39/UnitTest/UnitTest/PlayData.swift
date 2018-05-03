//
//  PlayData.swift
//  UnitTest
//
//  Created by Ben Hall on 03/05/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
// Class to store all words in the plays.txt file

import Foundation

struct PlayData {
    var allWords = [String]()
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                // Use CharacterSet to separate read-in string by anything that isn't a letter or number (.inverted)
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
            }
        }
    }
}
