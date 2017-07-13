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
    
    typealias PR_NUMBER = Int
    typealias ERROR_CB = (Error?) -> Void
    
    private static let GITHUB_BASE_URL = "https://api.github.com/repos/"
    private static let GITHUB_AUTHOR = "raywenderlich"
    private static let GITHUB_REPO = "swift-algorithm-club"
    
    static func getPullRequests(_ successCB:@escaping (_ response : [RealmGitHubPR]) -> Void, errorCB: @escaping ERROR_CB) -> Request {
        let request = Alamofire.request(GitHubRouter.getPRs())
        
        request.validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let obj = Mapper<RealmGitHubPR>().mapArray(JSONObject: value) {
                    successCB(obj)
                }
                else {
                    errorCB(nil)
                }
            case .failure(let error):
                errorCB(error)
            }
        }
        
        return request
     }
    
    static func getPullRequestByNumber(number: PR_NUMBER, successCB:@escaping (_ response : RealmGitHubPR) -> Void, errorCB: @escaping ERROR_CB) -> Request {
        let request = Alamofire.request(GitHubRouter.getPullRequestByNumber(number))
        
        request.validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let obj = Mapper<RealmGitHubPR>().map(JSONObject:value) {
                    successCB(obj)
                }
                else {
                    errorCB(nil)
                }
            case .failure(let error):
                errorCB(error)
            }
        }
        return request
    }
    
    static func getPullRequestDiff(diffUrl : String, successCB:@escaping (_ response : String) -> Void, errorCB: @escaping ERROR_CB) {
        let destination = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(diffUrl, to: destination)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progress) in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate().responseData { response in
                switch response.result {
                case .success(_):
                    guard let url = response.destinationURL else { errorCB(nil); return }
                    guard let fileText = try? String(contentsOf: url, encoding: String.Encoding.utf8) else { errorCB(nil); return }
                    guard let _ = try? FileManager.default.removeItem(at: url) else { errorCB(nil); return }
                    
                    successCB(fileText)
                case .failure(let error):
                    errorCB(error)
                }
            }
    }
    
    //MARK: - Private Variables
    fileprivate enum GitHubRouter: URLRequestConvertible {
        
        case getPRs()
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
            case .getPRs():
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
