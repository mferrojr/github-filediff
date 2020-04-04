//
//  SyncPRDetailsOperation.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

class SyncPRDetailsOperation : BaseOperation {
    
    // MARK: - Variables
    
    //MARK: Public
    var prNumber = 0

    // MARK: Private
    private let gitHubPREntityService = GitHubPREntityService()

    override func main() {
        super.main()
        getPRDetail()
    }
    
    private func getPRDetail(){
        self.dataTask = GitHubService.getPullRequestByNumber(number: prNumber) { result in
            switch result {
            case .success(let data):
                try? self.gitHubPREntityService.createPR(entity: data.toEntity())
                self.done()
            case .failure(let error):
                self.errorCB(error)
            }
        }
    }
    
}
