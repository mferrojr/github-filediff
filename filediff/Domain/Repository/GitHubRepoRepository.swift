//
//  GitHubRepoRepository.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine

protocol GitHubRepoRepository {
    func searchRepo(by input: String) -> AnyPublisher<GitHubSearch, Error>
}
