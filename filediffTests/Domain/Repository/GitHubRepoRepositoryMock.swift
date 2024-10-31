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
        GitHubSearch(items: [.init(id: 0, name: "name", fullName: "fullName")])
    }
    
}

struct GitHubRepoRepositoryMockFail: GitHubRepoRepository {
    func searchRepo(by input: String) -> AnyPublisher<GitHubSearch, any Error> {
        return Fail(error: GitHubRepoRepositoryMockError.fail)
            .eraseToAnyPublisher()
    }
    
}
