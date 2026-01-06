//
//  the_launch_first_projectUITestsLaunchTests.swift
//  the_launch_first_projectUITests
//
//  Created by najd aljarba on 03/04/1447 AH.
//

import XCTest

final class the_launch_first_projectUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
