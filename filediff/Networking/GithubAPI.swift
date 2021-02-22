//
//  GithubAPI.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/21/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

// Reference: https://github.com/V8tr/SwiftCombineNetworking
@available(swift, introduced: 1.1.0)
enum GithubAPI {
    static let agent = Agent()
    static let base = URL(string: "https://api.github.com/repos/raywenderlich/swift-algorithm-club")!
}

extension GithubAPI {

    // MARK: - Functions
    static func pullRequests() -> AnyPublisher<[GitHubPRResponse], Error> {
        let httpRequest = HTTPRequest(
            method: .get,
            baseURL: base,
            path: "pulls",
            queryItems: [ URLQueryItem(name: "state", value: "open") ]
        )
        
        return runForJson(httpRequest.requestURL)
    }
    
    static func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, Error> {
        let httpRequest = HTTPRequest(
            method: .get,
            baseURL: diffUrl
        )
        
        return runForString(httpRequest.requestURL)
    }
    
}

// MARK: - Private Functions
private extension GithubAPI {
    
    static func runForJson<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return agent.runForJson(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func runForString(_ request: URLRequest, with encoding: String.Encoding = .utf8) -> AnyPublisher<String, Error> {
        return agent.runForString(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
}
