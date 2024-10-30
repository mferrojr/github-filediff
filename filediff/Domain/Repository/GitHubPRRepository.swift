//
//  GitHubPRRepository.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import Foundation

protocol GitHubPRRepository {
    func pullRequests(for repo: GitHubRepo) -> AnyPublisher<[GitHubPullRequest], Error>
    func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, Error>
}
