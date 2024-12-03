//
//  PRDiffUITests.swift
//  filediffUITests
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import XCTest

class PRDiffUITests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        await XCUIApplication().launch()
    }

    @MainActor
    func test_searchForRepository_andViewPRDiff() {
        let app = XCUIApplication()
        let searchTextField = app.textFields[AccessibilityElement.TextFields.ID.searchForRepository.rawValue]
        XCTAssertTrue(searchTextField.exists)
        searchTextField.typeText("kodecocodes/swift-algorithm-club")
        let repositoryList = app.collectionViews[AccessibilityElement.Lists.ID.repository.rawValue]
        XCTAssertTrue(repositoryList.waitForExistence(timeout: 3))
        
        app.collectionViews[AccessibilityElement.Lists.ID.repository.rawValue]/*@START_MENU_TOKEN@*/.staticTexts["kodecocodes/swift-algorithm-club"]/*[[".cells.staticTexts[\"kodecocodes\/swift-algorithm-club\"]",".staticTexts[\"kodecocodes\/swift-algorithm-club\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
        let prList = app.collectionViews[AccessibilityElement.Lists.ID.pullRequests.rawValue]
        XCTAssertTrue(prList.waitForExistence(timeout: 3))
        
        let firstPRCell = prList.firstCell()
        XCTAssertTrue(firstPRCell.exists)
        firstPRCell.tap()
        
        let viewDiffButton = app.buttons[AccessibilityElement.Buttons.ID.viewPRDiff.rawValue]
        XCTAssertTrue(viewDiffButton.waitForExistence(timeout: 3))
        viewDiffButton.tap()
        
        let prDiffTable = app.tables[AccessibilityElement.Tables.ID.prDiff.rawValue]
        XCTAssertTrue(prDiffTable.waitForExistence(timeout: 3))
    }
}
