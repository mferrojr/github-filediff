//
//  GitHubDataSourceMock.swift
//  PR Diff ToolTests
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import Foundation
@testable import PR_Diff_Tool

enum GitHubDataSourceMockError: Error {
    case fail
}
struct GitHubDataSourceMock: GitHubDataSource {
    func searchRepo(by input: String) -> AnyPublisher<GitHubSearchResponse, any Error> {
        return Just(Self.generateSearch())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func pullRequests(for repo: PR_Diff_Tool.GitHubRepo) -> AnyPublisher<[GitHubPRResponse], any Error> {
        return Just([Self.generatePR()])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, any Error> {
        Just(Self.generateDiff())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static func generateSearch() -> GitHubSearchResponse {
        return GitHubSearchResponse(items: [.init(id: 0, name: "name", full_name: "full_name")])
    }
    
    static func generatePR() -> GitHubPRResponse {
        return GitHubPRResponse(id: 0, number: 3, diff_url: "diff_url", state: "state", title: "title", body: "body", created_at: "created_at", user: .init(id: 6, login: "login", avatar_url: .init(string:"http://avatar.url")!))
    }
    
    static func generateDiff() -> String {
        "diff"
    }
}

struct GitHubDataSourceMockFail: GitHubDataSource {
    func searchRepo(by input: String) -> AnyPublisher<PR_Diff_Tool.GitHubSearchResponse, any Error> {
        return Fail(error: GitHubDataSourceMockError.fail)
            .eraseToAnyPublisher()
    }
    
    func pullRequests(for repo: PR_Diff_Tool.GitHubRepo) -> AnyPublisher<[PR_Diff_Tool.GitHubPRResponse], any Error> {
        return Fail(error: GitHubDataSourceMockError.fail)
            .eraseToAnyPublisher()
    }
    
    func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, any Error> {
        return Fail(error: GitHubDataSourceMockError.fail)
            .eraseToAnyPublisher()
    }
}
