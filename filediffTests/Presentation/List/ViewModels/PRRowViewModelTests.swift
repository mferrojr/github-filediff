//
//  PRRowViewModelTests.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//


import XCTest
@testable import PR_Diff_Tool

final class PRRowViewModelTests: XCTestCase {

    func testInitialization_WithoutUser() {
        let entity = buildPR()
        let viewModel = PRRowViewModel(entity: entity)
        XCTAssertEqual(viewModel.title, "title")
        XCTAssertEqual(viewModel.subTitle, "#6")
    }
    
    func testInitialization_WithUser() {
        let entity = buildPR(user:
            .init(id: 5, login: "login", avatarUrl: URL(string: "http://avatar.url")!)
        )
        let viewModel = PRRowViewModel(entity: entity)
        XCTAssertEqual(viewModel.title, "title")
        XCTAssertEqual(viewModel.subTitle, "#6 opened by login")
    }
}

private extension PRRowViewModelTests {
    
    func buildPR(user: GitHubRepoOwner? = nil) -> GitHubPullRequest {
        return GitHubPullRequest(
            id: 3,
            body: nil,
            created_at: nil,
            diff_url: "diff_url",
            number: 6,
            state: nil,
            title: "title",
            user: user
        )
    }
}
