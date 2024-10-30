//
//  GithubAPI.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

protocol GitHubDataSource {
    func searchRepo(by input: String) -> AnyPublisher<GitHubSearchResponse, Error>
    func pullRequests(for repo: GitHubRepo) -> AnyPublisher<[GitHubPRResponse], Error>
    func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, Error>
}
