//
//  GitHubRepoRepositoryLocal.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import Foundation
@testable import PR_Diff_Tool

enum GitHubRepoRepositoryMockError: Error {
    case fail
}

struct GitHubRepoRepositoryMock: GitHubRepoRepository {
    func searchRepo(by input: String) -> AnyPublisher<GitHubSearch, any Error> {
        return Just(Self.generateSearch())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static func generateSearch() -> GitHubSearch {
        return GitHubSearch(items: [
            .init(id: 0, name: "name", fullName: "nameFull"),
            .init(id: 1, name: "test", fullName: "testFull"),
            .init(id: 2, name: "test2", fullName: "test2Full"),
            .init(id: 3, name: "abc", fullName: "abcFul")
        ])
    }
    
    static func generateSearchSorted() -> [RepoByLetterItem] {
        let items = generateSearch().items
        return [
            RepoByLetterItem(id: "A", repos: [items[3]]),
            RepoByLetterItem(id: "N", repos: [items[0]]),
            RepoByLetterItem(id: "T", repos: [items[2], items[1]])
        ]
    }
    
}

struct GitHubRepoRepositoryMockFail: GitHubRepoRepository {
    func searchRepo(by input: String) -> AnyPublisher<GitHubSearch, any Error> {
        return Fail(error: GitHubRepoRepositoryMockError.fail)
            .eraseToAnyPublisher()
    }
    
}
