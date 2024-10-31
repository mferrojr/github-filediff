//
//  PRDetailsViewModelTests.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import XCTest
@testable import PR_Diff_Tool

final class PRDetailsViewModelTests: XCTestCase {

    func testInitialization() {
        let entity = GitHubPullRequest(
            id: 3,
            body: nil,
            created_at: nil,
            diff_url: "diff_url",
            number: 6,
            state: nil,
            title: nil,
            user: nil
        )
        let viewModel = PRDetailsViewModel(entity: entity)
        XCTAssertEqual(viewModel.title, "PR #6")
        XCTAssertEqual(viewModel.btnTitle, .localize(.viewDiff))
    }
}
