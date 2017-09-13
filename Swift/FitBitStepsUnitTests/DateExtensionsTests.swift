//
//  DateExtensionsTests.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/11/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import XCTest
@testable import FitBit_Steps

class DateExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Naming is three part:
    // 1.) Prefix test   - What is being tested
    // 2.) Prefix With   - Under what circumstances
    // 3.) Prefix Should - What is the expected result
    func testGetNextDateStr_WithHappyPath_ShouldReturnExpectedNextDateStr() {
        let dateStr: String = "2017-09-11"
        let expectedNextDateStr = "2017-09-12"
        let newDateStr: String? = Date.getNextDateStr(dateStr, .dashYMD)
        
        if let sureNewDateStr = newDateStr {
            XCTAssert(sureNewDateStr == expectedNextDateStr)
        } else {
            XCTAssert(false)
        }
    }
}
