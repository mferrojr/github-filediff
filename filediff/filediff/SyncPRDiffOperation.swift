//
//  SyncPRDiffOperation.swift
//  filediff
//
//  Created by Michael Ferro on 7/12/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

class SyncPRDiffOperation : BaseOperation {
    
    //MARK: - Public Variables
    var diffUrl = ""
    
    override func main() {
        super.main()
        getPRDiff()
    }
    
    private func getPRDiff(){
        //self.request = GitHubService.getPullRequests(successCB, errorCB: errorCB)
    }
    
    private func successCB(_ response : [RealmGitHubPR]) {
        self.done()
    }
    
}
