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
    fileprivate var diffUrl = ""
    fileprivate var context : FileDiffQueueContext!
    
    required init(diffUrl : String, context : FileDiffQueueContext) {
        self.diffUrl = diffUrl
        self.context = context
    }
    
    override func main() {
        super.main()
        getPRDiff()
    }
    
    private func getPRDiff(){
        self.request = GitHubService.getPullRequestDiff(diffUrl: diffUrl, successCB: successCB, errorCB: errorCB)
    }
    
    private func successCB(_ response : String) {
        self.context.fileText = response
        self.done()
    }
    
}
