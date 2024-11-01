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
    func test_searchForRepository_andViewPRDiff() {
        let app = XCUIApplication()
        app.textFields["Search for repository..."].typeText("swift-algorithm-club")
        
        let repositoryList = app.collectionViews["LIST_REPOSITORY"]
        XCTAssertTrue(repositoryList.waitForExistence(timeout: 3))
        
        let swiftAlgorithmClubCell = repositoryList.firstCell()
        XCTAssertTrue(swiftAlgorithmClubCell.exists)
        swiftAlgorithmClubCell.tap()
        
        let prList = app.collectionViews["LIST_PR"]
        XCTAssertTrue(prList.waitForExistence(timeout: 3))
        
        let firstPRCell = prList.firstCell()
        XCTAssertTrue(firstPRCell.exists)
        firstPRCell.tap()
        
        let viewDiffButton = app.buttons["View PR Diff"]
        XCTAssertTrue(viewDiffButton.waitForExistence(timeout: 3))
        viewDiffButton.tap()
        
        let prDiffTable = app.tables["TABLE_PR_DIFF"]
        XCTAssertTrue(prDiffTable.waitForExistence(timeout: 3))
    }
    
}

private extension XCUIElement {
    
    func firstCell() -> XCUIElement {
        self.cells.children(matching: .any).element(boundBy: 0)
    }
}
