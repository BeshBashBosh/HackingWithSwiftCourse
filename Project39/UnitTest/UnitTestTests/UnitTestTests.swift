//
//  UnitTestTests.swift
//  UnitTestTests
//
//  Created by Ben Hall on 02/05/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import XCTest
@testable import UnitTest

class UnitTestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - How to XCTest
    // For XCTesting name testing functions by starting them with "test".
    // Also the function should accept no params and have no return types.
    // XC then recognises such a method as a test that should be run on the code. This is identified by the
    // diamond shape in the gutter to the left. Hovering over this turns it to a play button that will run the test!
    
    // This XCTest measures the performance speed of particular code!
    func testWordsLoadQuickly() {
        measure {
            _ = PlayData()
        }
    }
    
    func testAllWordsLoaded() {
        let playData = PlayData() // instantiate a playData object
        // if XCAssertEqual passes true, the test was a success!
        XCTAssertEqual(playData.allWords.count, 18440, "allWords was not 18440") // XC Assertion test that the allWords property has 0 words
    }
    
    func testWordCountsAreCorrect() {
        let playData = PlayData()
        XCTAssertEqual(playData.wordsCount.count(for: "home"), 174, "Home does not appear 174 times")
        XCTAssertEqual(playData.wordsCount.count(for: "fun"), 4, "Fun does not appear 4 times")
        XCTAssertEqual(playData.wordsCount.count(for: "mortal"), 41, "Mortal does not appear 41 times")
    }
    
    
    func testApplyingFilter() {
        let playData = PlayData()
        
        playData.applyUserFilter("100")
        XCTAssertEqual(playData.filteredWords.count, 495, "Occurrence of a words occurring >=100 times is not 495")
        
        playData.applyUserFilter("1000")
        XCTAssertEqual(playData.filteredWords.count, 55, "Occurrence of a words occurring >=1000 times is not 55")
        
        playData.applyUserFilter("10000")
        XCTAssertEqual(playData.filteredWords.count, 1, "Occurrence of a words occurring >=10000 times is not 1")
        
        playData.applyUserFilter("test")
        XCTAssertEqual(playData.filteredWords.count, 56, "'test' does not appear 56 times")
        
        playData.applyUserFilter("swift")
        XCTAssertEqual(playData.filteredWords.count, 7, "'swift' does not appear 7 times")
        
        playData.applyUserFilter("objective-c")
        XCTAssertEqual(playData.filteredWords.count, 0, "'objective-c' does not appear 0 times")
        
        
    }
}
