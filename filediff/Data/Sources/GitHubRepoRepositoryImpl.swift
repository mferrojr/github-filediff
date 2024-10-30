//
//  GitHubRepoRepositoryImpl.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import Foundation

struct GitHubRepoRepositoryImpl {
    typealias GitHubInstance = (GitHubDataSource) -> GitHubRepoRepositoryImpl
    
    fileprivate let dataSource: GitHubDataSource
    
    private init(dataSource: GitHubDataSource) {
        self.dataSource = dataSource
    }
    
    static let sharedInstance: GitHubInstance = { dataSource in
        return GitHubRepoRepositoryImpl(dataSource: dataSource)
    }
}

extension GitHubRepoRepositoryImpl: GitHubRepoRepository {
    
    func searchRepo(by input: String) -> AnyPublisher<GitHubSearch, any Error> {
        return dataSource.searchRepo(by: input)
            .map { responses -> GitHubSearch in
                responses.toModel()
            }
            .eraseToAnyPublisher()
    }
}
