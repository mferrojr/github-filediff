//
//  SyncPRsOperation.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Alamofire
import Foundation

class SyncPRsOperation : BaseOperation {
    
    override func main() {
        super.main()
        getPRs()
    }
    
    private func getPRs(){
        self.request = GitHubService.getPullRequests() { result in
            switch result {
            case .success(let results):
                self.saveArrayToRealm(results)
            case .failure(let error):
                self.errorCB(error.underlyingError)
            }
        }
    }

}
