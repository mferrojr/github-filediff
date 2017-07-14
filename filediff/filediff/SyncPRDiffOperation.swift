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
    var fileText : String!
    
    override func main() {
        super.main()
        getPRDiff()
    }
    
    private func getPRDiff(){
        self.request = GitHubService.getPullRequestDiff(diffUrl: diffUrl, successCB: successCB, errorCB: errorCB)
    }
    
    private func successCB(_ response : String) {
        self.fileText = response
        self.done()
    }
    
}
