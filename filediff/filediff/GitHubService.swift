//
//  GitHubService.swift
//  filediff
//
//  Created by Michael Ferro on 7/9/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Alamofire
import RealmSwift

enum GitHubServiceError : Error {
    case MalFormedUrl
    case InvalidResponse
}

final class GitHubService {
    
    typealias PR_NUMBER = Int
    typealias ERROR_CB = (Error?) -> Void
    
    private static let GITHUB_BASE_URL = "https://api.github.com/repos/"
    private static let GITHUB_AUTHOR = "raywenderlich"
    private static let GITHUB_REPO = "swift-algorithm-club"
    
    static func getPullRequests(_ completion:@escaping (Result<[GitHubPR], AFError>)->Void) -> Request {
        let request = AF.request(GitHubRouter.getPRs)

        request.validate()
        .responseDecodable(of: [GitHubPR].self) { response in
            completion(response.result)
        }
        
        return request
     }
    
    static func getPullRequestByNumber(number: PR_NUMBER, completion:@escaping (Result<GitHubPR, AFError>)->Void) -> Request {
        let request = AF.request(GitHubRouter.getPullRequestByNumber(number))
        
        request.validate()
        .responseDecodable(of: GitHubPR.self) { response in
            completion(response.result)
        }

        return request
    }
    
    static func getPullRequestDiff(diffUrl : String, completion:@escaping (Result<String, AFError>)->Void) -> Request {
        let destination = DownloadRequest.suggestedDownloadDestination()
        
        let request = AF.download(diffUrl, to: destination)
        
        request.validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(String(decoding: data, as: UTF8.self)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return request
    }
    
    //MARK: - Private Variables
    fileprivate enum GitHubRouter: URLRequestConvertible {
        
        case getPRs
        case getPullRequestByNumber(Int)
        
        fileprivate var method: Alamofire.HTTPMethod {
            switch self {
            default:
                return .get
            }
        }
        
        fileprivate var path: String {
            let base = "\(GITHUB_AUTHOR)/\(GITHUB_REPO)"
            
            switch self {
            case .getPRs:
                return "\(base)/pulls?state=open"
            case .getPullRequestByNumber(let number):
                return "\(base)/pulls/\(number)"
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            var url = GITHUB_BASE_URL
            url.append(path)
            
            guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw GitHubServiceError.MalFormedUrl }
            guard let completeUrl = URL(string: encodedUrl) else { throw GitHubServiceError.MalFormedUrl }
            
            var request = URLRequest(url: completeUrl)
            request.httpMethod = method.rawValue
            
            switch self {
            default:
                return request
            }
        }
        
    }

}
