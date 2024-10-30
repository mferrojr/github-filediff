//
//  GitHubRemoteDataSource.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//
import Combine
import Foundation

struct GitHubRemoteDataSource {
    let agent: Agent = Agent()
    let baseUrl: URL = URL(string: "https://api.github.com")!
}

extension GitHubRemoteDataSource: GitHubDataSource {

    // MARK: - Functions
    
    /// Searches for GitHub Repositories
    /// [Reference](https://docs.github.com/en/rest/search/search?apiVersion=2022-11-28#search-repositories)
    func searchRepo(by input: String) -> AnyPublisher<GitHubSearchResponse, Error> {
        let httpRequest = HTTPRequest(
            method: .get,
            baseURL: baseUrl,
            path: "/search/repositories",
            queryItems: [ URLQueryItem(name: "q", value: input) ]
        )
        return runForJson(httpRequest.requestURL)
    }
    
    /// Retrieves all open Pull Requests
    /// [Reference](https://docs.github.com/en/rest/pulls/pulls?apiVersion=2022-11-28#list-pull-requests)
    func pullRequests(for repo: GitHubRepo) -> AnyPublisher<[GitHubPRResponse], Error> {
        let httpRequest = HTTPRequest(
            method: .get,
            baseURL: baseUrl,
            path: "repos/\(repo.fullName)/pulls",
            queryItems: [ URLQueryItem(name: "state", value: "open") ]
        )
        return runForJson(httpRequest.requestURL)
    }
    
    /// Retrieves raw representation of the Pull Request
    func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, Error> {
        let httpRequest = HTTPRequest(
            method: .get,
            baseURL: diffUrl
        )
        return runForString(httpRequest.requestURL)
    }
    
}

// MARK: - Private Functions
private extension GitHubRemoteDataSource {
    
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
