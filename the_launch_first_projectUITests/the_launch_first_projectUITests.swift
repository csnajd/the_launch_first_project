//
//  the_launch_first_projectUITests.swift
//  the_launch_first_projectUITests
//
//  Created by najd aljarba on 03/04/1447 AH.
//

import XCTest

final class the_launch_first_projectUITests: XCTestCase {

    override func setUpWithError() throws {
    
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
