//
//  GitHubPRRepositoryMock.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import Foundation
@testable import PR_Diff_Tool

enum GitHubPRRepositoryMockError: Error {
    case fail
}
struct GitHubPRRepositoryMock: GitHubPRRepository {
    
    func pullRequests(for repo: GitHubRepo) -> AnyPublisher<[GitHubPullRequest], any Error> {
        return Just([Self.generatePR()])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, any Error> {
        Just("diff_url")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static func generateUser() -> GitHubRepoOwner {
        GitHubRepoOwner(
            id: 0, login: "login", avatarUrl: URL(string: "https://developer.apple.com/assets/elements/icons/swiftui/swiftui-96x96_2x.png")!)
    }
    
    static func generatePR() -> GitHubPullRequest {
        GitHubPullRequest(id: 0, body: "body", created_at: "created_at", diff_url: "diff_url", number: 2, state: "state", title: "title", user: generateUser())
    }
}

struct GitHubPRRepositoryMockFail: GitHubPRRepository {
    func pullRequests(for repo: GitHubRepo) -> AnyPublisher<[GitHubPullRequest], any Error> {
        return Fail(error: GitHubPRRepositoryMockError.fail)
            .eraseToAnyPublisher()
    }
    
    func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, any Error> {
        return Fail(error: GitHubPRRepositoryMockError.fail)
            .eraseToAnyPublisher()
    }
}
