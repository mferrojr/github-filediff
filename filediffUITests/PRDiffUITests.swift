//
//  PRDiffUITests.swift
//  filediffUITests
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import XCTest

class PRDiffUITests: XCTestCase {
    @MainActor
    override func setUp() {
        super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }

    @MainActor
    func test_searchForRepository() {
        let app = XCUIApplication()
        app.textFields["Search for repository..."].tap()
        app.textFields["Search for repository..."].typeText("swift-algor")
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["swift-algorithm-club"]/*[[".cells.staticTexts[\"swift-algorithm-club\"]",".staticTexts[\"swift-algorithm-club\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
}
