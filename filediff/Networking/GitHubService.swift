//
//  GitHubService.swift
//  filediff
//
//  Created by Michael Ferro on 7/9/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

enum GitHubServiceError : Error {
    case MalFormedUrl
    case InvalidResponse
}

final class GitHubService {
    
    typealias PR_NUMBER = Int
    typealias ERROR_CB = (Error?) -> Void

    private static let apiBaseURL = URL(string: "https://api.github.com/repos/raywenderlich/swift-algorithm-club")!
    
    static func getPullRequests(_ completion:@escaping (Result<[GitHubPRResponse], Error>)->Void) -> URLSessionDataTask? {
        let request = HTTPRequest(method: .get, baseURL: apiBaseURL, path: "pulls")
        request.queryItems = [ URLQueryItem(name: "state", value: "open") ]

        return HTTPClient().perform(request) { result in
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: [GitHubPRResponse].self) {
                    completion(.success(response.body))
                } else {
                    completion(.failure(GitHubServiceError.InvalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
     }
    
    static func getPullRequestByNumber(number: PR_NUMBER, completion:@escaping (Result<GitHubPRResponse, Error>)->Void) -> URLSessionDataTask? {
        let request = HTTPRequest(method: .get, baseURL: apiBaseURL, path: "pulls/\(number)")

        return HTTPClient().perform(request) { result in
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: GitHubPRResponse.self) {
                    completion(.success(response.body))
                } else {
                    completion(.failure(GitHubServiceError.InvalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getPullRequestDiff(diffUrl : String, completion:@escaping (Result<String, Error>)->Void) throws -> URLSessionDataTask? {
        guard let url = URL(string: diffUrl) else {
            throw GitHubServiceError.MalFormedUrl
        }
        
        let request = HTTPRequest(method: .get, baseURL: url, path: "")

        return HTTPClient().perform(request) { result in
            switch result {
            case .success(let response):
                if let body = response.body, let result = String(data: body, encoding: .utf8) {
                    completion(.success(result))
                } else {
                    completion(.failure(GitHubServiceError.InvalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
