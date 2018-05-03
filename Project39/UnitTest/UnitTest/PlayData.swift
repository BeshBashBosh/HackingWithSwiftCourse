//
//  PlayData.swift
//  UnitTest
//
//  Created by Ben Hall on 03/05/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//
// Class to store all words in the plays.txt file

import Foundation

class PlayData {
    
    var allWords = [String]()
    var wordsCount: NSCountedSet!
    private(set) var filteredWords = [String]()
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                
                // Use CharacterSet to separate read-in string by anything that isn't a letter or number (.inverted)
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
                
                // Filter out blank characters
                allWords = allWords.filter { $0 != "" }
                
                // Re-factored word occurrence property using NSCountedSet
                wordsCount = NSCountedSet(array: allWords) // creates counted set of words, immediately de-duplicating entries and counting them all
                // Sort words by count occurrence in the NSCountedSet
                let sorted = wordsCount.allObjects.sorted { wordsCount.count(for: $0) > wordsCount.count(for: $1) }
                // extract unique words and reinit allWords property
                allWords = sorted as! [String]
                
            }
        }
    }
    
    
    func applyUserFilter(_ input: String) {
        if let userNumber = Int(input) {
            // a number!
            // Filter out only words with at least this number of occurrences
            self.applyFilter { self.wordsCount.count(for: $0) >= userNumber }
        } else {
            // a string!
            // Filter out only words matching this string
            self.applyFilter { $0.range(of: input, options: .caseInsensitive) != nil }
        }
    }
    
    func applyFilter(_ filter: (String) -> Bool) {
        filteredWords = allWords.filter(filter)
    }
}
