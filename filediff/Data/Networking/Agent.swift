//
//  Agent.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

@available(swift, introduced: 1.1.0)
enum AgentError: Error {
    case invalidResponse
}

@available(swift, introduced: 1.1.0)
struct Agent {
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    // MARK: - Variables
    
    // MARK: Private
    private let session = URLSession.shared

    // MARK: - Functions
    func runForJson<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return session
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .eraseToAnyPublisher()
    }
    
    func runForString(_ request: URLRequest, with encoding: String.Encoding = .utf8) -> AnyPublisher<Response<String>, Error> {
        return session
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<String> in
                if let stringResponse = String(data: result.data, encoding: encoding) {
                    return Response(value: stringResponse, response: result.response)
                } else {
                    throw AgentError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
}
