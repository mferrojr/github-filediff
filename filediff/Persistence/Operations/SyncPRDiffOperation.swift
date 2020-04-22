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
    fileprivate var diffUrl: URL
    fileprivate var context: FileDiffQueueContext!
    
    required init(diffUrl : URL, context : FileDiffQueueContext) {
        self.diffUrl = diffUrl
        self.context = context
    }
    
    override func main() {
        super.main()
        getPRDiff()
    }
    
    private func getPRDiff(){
        self.subscription =
            GithubAPI.pullRequestBy(diffUrl: diffUrl)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case .finished:
                       break
                    case .failure(let error):
                       self.errorCB(error)
                    }
                    self.done()
                },
                receiveValue: { result in
                    self.context.fileText = result
                    self.done()
                }
            )
    }
    
}
