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
        self.request = GitHubService.getPullRequestByNumber(number: prNumber, successCB: successCB, errorCB: errorCB)
    }
    
    private func successCB(_ response : RealmGitHubPR) {
        self.saveToRealm(response)
    }
    
}
