//
//  PRDetailsViewModelTests.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import Testing
@testable import PR_Diff_Tool

struct PRDetailsViewModelTests {

    @Test
    func init_empty() {
        let entity = GitHubPullRequest(
            id: 3,
            body: nil,
            created_at: "nil",
            diff_url: "",
            number: 6,
            state: "open",
            title: "title",
            user: nil
        )
        let viewModel = PRDetailsViewModel(entity: entity)
        #expect(viewModel.title == "PR #6")
        #expect(viewModel.btnTitle == "View PR Diff")
        #expect(viewModel.body == "")
        #expect(viewModel.entity == entity)
    }
    
    @Test
    func init_notEmpty() {
        let entity = GitHubPullRequest(
            id: 3,
            body: "body",
            created_at: "created_at",
            diff_url: "diff_url",
            number: 6,
            state: "state",
            title: "title",
            user: .init(id: 0, login: "login", avatarUrl: URL(string: "http://avatar.url")!)
        )
        let viewModel = PRDetailsViewModel(entity: entity)
        #expect(viewModel.title == "PR #6")
        #expect(viewModel.btnTitle == "View PR Diff")
        #expect(viewModel.body == "body")
        #expect(viewModel.entity == entity)
    }
}
