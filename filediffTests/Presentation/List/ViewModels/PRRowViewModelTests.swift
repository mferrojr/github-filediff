//
//  PRRowViewModelTests.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import Testing
@testable import PR_Diff_Tool

struct PRRowViewModelTests {

    @Test
    func init_withoutData() {
        let entity = GitHubPullRequest(
            id: 3,
            body: nil,
            created_at: "created_at",
            diff_url: "",
            number: 6,
            state: "open",
            title: "title",
            user: nil
        )
        let viewModel = PRRowViewModel(entity: entity)
        #expect(viewModel.title == "title")
        #expect(viewModel.prTitle == "#6 opened by")
        #expect(viewModel.userTitle == "N/A")
        #expect(viewModel.avatarUrl == nil)
    }
    
    @Test
    func init_withData() {
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
        #expect(viewModel.title == "title")
        #expect(viewModel.prTitle == "#6 opened by")
        #expect(viewModel.userTitle == "login")
        #expect(viewModel.avatarUrl == URL(string: "http://avatar.url")!)
    }
}
