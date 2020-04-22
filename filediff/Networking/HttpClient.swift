//
//  HttpClient.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 3/28/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

@available(swift, deprecated: 1.1.0)
struct HTTPResponse<Body> {
    let statusCode: Int
    let body: Body
}

@available(swift, deprecated: 1.1.0)
extension HTTPResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> HTTPResponse<BodyType> {
        guard let data = body else {
            throw HTTPError.decodingFailure
        }
        let decodedJSON = try JSONDecoder().decode(BodyType.self, from: data)
        return HTTPResponse<BodyType>(statusCode: self.statusCode,
                                     body: decodedJSON)
    }
}

@available(swift, deprecated: 1.1.0)
enum HTTPError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure
    case statusCode
}

@available(swift, deprecated: 1.1.0)
enum HTTPResult<Body> {
    case success(HTTPResponse<Body>)
    case failure(HTTPError)
}

@available(swift, deprecated: 1.1.0)
struct HTTPClient {

    typealias HTTPClientCompletion = (HTTPResult<Data?>) -> Void

    private let session = URLSession.shared

    func perform(_ request: HTTPRequest, _ completion: @escaping HTTPClientCompletion) -> URLSessionDataTask? {
        var urlComponents = URLComponents()
        urlComponents.scheme = request.baseURL.scheme
        urlComponents.host = request.baseURL.host
        urlComponents.path = request.baseURL.path
        urlComponents.queryItems = request.queryItems

        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(.invalidURL))
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body

        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }

        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            completion(.success(HTTPResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
        }
        task.resume()
        
        return task
    }

}
