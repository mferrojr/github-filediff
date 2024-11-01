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

    func test_init_withoutData() {
        let entity = GitHubPullRequest(
            id: 3,
            body: nil,
            created_at: nil,
            diff_url: "",
            number: 6,
            state: nil,
            title: nil,
            user: nil
        )
        let viewModel = PRRowViewModel(entity: entity)
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.prTitle, "#6 opened by")
        XCTAssertEqual(viewModel.userTitle, "N/A")
        XCTAssertEqual(viewModel.avatarUrl, nil)
    }
    
    func test_init_withData() {
        let entity = GitHubPullRequest(
            id: 3,
            body: "body",
            created_at: "created_at",
            diff_url: "diff_url",
            number: 6,
            state: "state",
            title: "title",
            user: .init(id: 5, login: "login", avatarUrl: URL(string: "http://avatar.url")!)
        )
        let viewModel = PRRowViewModel(entity: entity)
        XCTAssertEqual(viewModel.title, "title")
        XCTAssertEqual(viewModel.prTitle, "#6 opened by")
        XCTAssertEqual(viewModel.userTitle, "login")
        XCTAssertEqual(viewModel.avatarUrl, URL(string: "http://avatar.url")!)
    }
}
