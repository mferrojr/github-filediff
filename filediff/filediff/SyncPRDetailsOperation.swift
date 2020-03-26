//
//  SyncPRDetailsOperation.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

class SyncPRDetailsOperation : BaseOperation {
    
    //MARK: - Public Variables
    var prNumber = 0
    
    override func main() {
        super.main()
        getPRDetail()
    }
    
    private func getPRDetail(){
        self.request = GitHubService.getPullRequestByNumber(number: prNumber) { result in
            switch result {
            case .success(let data):
                self.saveToRealm(data)
            case .failure(let error):
                self.errorCB(error.underlyingError)
            }
        }
    }
    
}
