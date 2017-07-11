//
//  GitHubService.swift
//  filediff
//
//  Created by Michael Ferro on 7/9/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireNetworkActivityIndicator
import RealmSwift

enum GitHubServiceError : Error {
    case MalFormedUrl
    case InvalidResponse
}

final class GitHubService {
    
    typealias PR_NUMBER = String
    
    private static let GITHUB_BASE_URL = "https://api.github.com/repos/"
    private static let GITHUB_AUTHOR = "raywenderlich"
    private static let GITHUB_REPO = "swift-algorithm-club"
    
    static func getPullRequests(_ successCB:@escaping (_ response : [RealmGitHubPR]) -> Void, errorCB: @escaping (Error?,Int?) -> Void) {
        Alamofire.request(GitHubRouter.getPRs()).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let obj = Mapper<RealmGitHubPR>().mapArray(JSONObject: value) {
                    successCB(obj)
                }
                else {
                    errorCB(nil,nil)
                }
            case .failure(let error):
                errorCB(error,nil)
            }
        }
     }
    
    static func getPullRequestDetail(number: PR_NUMBER, successCB:@escaping (_ response : RealmGitHubPR) -> Void, errorCB: @escaping (Error?,Int?) -> Void) {
        Alamofire.request(GitHubRouter.getPullRequestDetail(number)).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let obj = Mapper<RealmGitHubPR>().map(JSONObject:value) {
                    successCB(obj)
                }
                else {
                    errorCB(nil,nil)
                }
            case .failure(let error):
                errorCB(error,nil)
            }
        }
    }
    
    static func getPullRequestDiff(base : String, head : String, successCB:@escaping (_ response : RealmGitHubPR) -> Void, errorCB: @escaping (Error?,Int?) -> Void) {
        Alamofire.request(GitHubRouter.getPullRequestDiff(base, head)).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let obj = Mapper<RealmGitHubPR>().map(JSONObject:value) {
                    successCB(obj)
                }
                else {
                    errorCB(nil,nil)
                }
            case .failure(let error):
                errorCB(error,nil)
            }
        }
    }
    
    
    //MARK: - Private Variables
    fileprivate enum GitHubRouter: URLRequestConvertible {
        
        case getPRs()
        case getPullRequestDetail(String)
        case getPullRequestDiff(String, String)
        
        fileprivate var method: Alamofire.HTTPMethod {
            switch self {
            default:
                return .get
            }
        }
        
        fileprivate var path: String {
            let base = "\(GITHUB_AUTHOR)/\(GITHUB_REPO)"
            
            switch self {
            case .getPRs():
                return "\(base)/pulls?state=open"
            case .getPullRequestDetail(let number):
                return "\(base)/pulls/\(number)"
            case .getPullRequestDiff(let base, let head):
                return "\(base)/compare/:\(base)...:\(head)"
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
