//
//  GitHubPRRepositoryImpl.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import Foundation

struct GitHubPRRepositoryImpl {
    @Service
    var dataSource: GitHubDataSource
}

extension GitHubPRRepositoryImpl: GitHubPRRepository {
    
    func pullRequests(for repo: GitHubRepo) -> AnyPublisher<[GitHubPullRequest], Error> {
        return dataSource.pullRequests(for: repo)
            .map { responses -> [GitHubPullRequest] in
                responses.map { $0.toModel() }
            }
            .eraseToAnyPublisher()
    }
    
    func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, Error> {
        return dataSource.pullRequestBy(diffUrl: diffUrl)
    }
}
