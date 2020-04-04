//
//  SyncPRsOperation.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

class SyncPRsOperation : BaseOperation {

    // MARK: - Variables
    
    // MARK: Private
    private let gitHubPREntityService = GitHubPREntityService()

    override func main() {
        super.main()
        getPRs()
    }
    
    // MARK: - Functions
    
    // MARK: Private
    private func getPRs(){
        self.dataTask = GitHubService.getPullRequests() { result in
            switch result {
            case .success(let results):
                try? self.gitHubPREntityService.createAllPRs(entities: results.map { $0.toEntity() })
                self.done()
            case .failure(let error):
                self.errorCB(error)
            }
        }
    }

}
