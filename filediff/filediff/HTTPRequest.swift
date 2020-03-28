//
//  APIRequest.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 3/28/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

struct HTTPHeader {
    let field: String
    let value: String
}

class HTTPRequest {
    let baseURL: URL
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?

    init(method: HTTPMethod, baseURL: URL, path: String) {
        self.method = method
        self.baseURL = baseURL
        self.path = path
    }

    init<Body: Encodable>(method: HTTPMethod, baseURL: URL, path: String, body: Body) throws {
        self.method = method
        self.baseURL = baseURL
        self.path = path
        self.body = try JSONEncoder().encode(body)
    }
}
