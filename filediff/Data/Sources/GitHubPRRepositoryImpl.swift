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
    typealias GitHubInstance = (GitHubDataSource) -> GitHubPRRepositoryImpl
    
    fileprivate let dataSource: GitHubDataSource
    
    private init(dataSource: GitHubDataSource) {
        self.dataSource = dataSource
    }
    
    static let sharedInstance: GitHubInstance = {  dataSource in
        return GitHubPRRepositoryImpl(dataSource: dataSource)
    }
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
