//
//  JobFinderTests.swift
//  Job FinderTests
//
//  Created by Deependra Dhakal on 3/5/19.
//  Copyright © 2019 Deependra Dhakal. All rights reserved.
//

import XCTest
@testable import Job_Finder

class JobFinderTests: XCTestCase {
    
    var controller = ViewController()
    
    /// Tests whether the function format date correctly
    func testDateFormatter() {
        let date1 : String = "Mon Feb 18 08:58:54 UTC 2019"
        let date2 : String = "2018-02-19"
        XCTAssertEqual(controller.dateFormatter(format: date1), "18/02/2019")
        XCTAssertEqual(controller.dateFormatter(format: date2), "19/02/2018")
    }
    
}
