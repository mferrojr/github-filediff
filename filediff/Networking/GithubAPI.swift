//
//  GithubAPI.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/21/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

protocol GitHubAPIable {
    func searchRepo(by input: String) -> AnyPublisher<GitHubSearchResponse, Error>
    func pullRequests(for repo: GitHubRepoEntity) -> AnyPublisher<[GitHubPRResponse], Error>
    func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, Error>
}
struct GithubAPI {
    let agent: Agent = Agent()
    let baseUrl: URL = URL(string: "https://api.github.com")!
}

extension GithubAPI: GitHubAPIable {

    // MARK: - Functions
    func searchRepo(by input: String) -> AnyPublisher<GitHubSearchResponse, Error> {
        let httpRequest = HTTPRequest(
            method: .get,
            baseURL: baseUrl,
            path: "/search/repositories",
            queryItems: [ URLQueryItem(name: "q", value: input) ]
        )
        return runForJson(httpRequest.requestURL)
    }
    
    func pullRequests(for repo: GitHubRepoEntity) -> AnyPublisher<[GitHubPRResponse], Error> {
        let httpRequest = HTTPRequest(
            method: .get,
            baseURL: baseUrl,
            path: "repos/\(repo.fullName)/pulls",
            queryItems: [ URLQueryItem(name: "state", value: "open") ]
        )
        return runForJson(httpRequest.requestURL)
    }
    
    func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, Error> {
        let httpRequest = HTTPRequest(
            method: .get,
            baseURL: diffUrl
        )
        return runForString(httpRequest.requestURL)
    }
    
}

// MARK: - Private Functions
private extension GithubAPI {
    
    func runForJson<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return agent.runForJson(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func runForString(_ request: URLRequest, with encoding: String.Encoding = .utf8) -> AnyPublisher<String, Error> {
        return agent.runForString(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
}
