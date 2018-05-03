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
    var wordsCount = [String: Int]()
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                
                // Use CharacterSet to separate read-in string by anything that isn't a letter or number (.inverted)
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
                
                // Filter out blank characters
                allWords = allWords.filter { $0 != "" }
                
                // Count up occurrence of unique words
                for word in allWords {
                    if wordsCount[word] == nil {
                        wordsCount[word] = 1
                    } else {
                        wordsCount[word]! += 1
                    }
                }
                
                // Remove duplicate words from allWords array
                allWords = Array(wordsCount.keys)
            }
        }
    }
}
