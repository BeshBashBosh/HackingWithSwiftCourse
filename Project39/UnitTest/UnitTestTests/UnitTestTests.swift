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
    func testAllWordsLoaded() {
        let playData = PlayData() // instantiate a playData object
        // if XCAssertEqual passes true, the test was a success!
        XCTAssertEqual(playData.allWords.count, 18440, "allWords was not 18440") // XC Assertion test that the allWords property has 0 words
    }
    
    func testWordCountsAreCorrect() {
        let playData = PlayData()
        XCTAssertEqual(playData.wordsCount["home"], 174, "Home does not appear 174 times")
        XCTAssertEqual(playData.wordsCount["fun"], 4, "Fun does not appear 4 times")
        XCTAssertEqual(playData.wordsCount["mortal"], 41, "Mortal does not appear 41 times")
    }
}
