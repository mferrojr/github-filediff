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
    @Service
    var dataSource: GitHubDataSource
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
