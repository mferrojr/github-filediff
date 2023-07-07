//
//  SyncPRsOperation.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

final class SyncPRsOperation: BaseOperation {

    // MARK: - Properties
    
    // MARK: Private
    private let gitHubPREntityService: GitHubPREntityServicable

    // MARK: - Initialization
    required init(prService: GitHubPREntityServicable) {
       self.gitHubPREntityService = prService
    }
    
    // MARK: - Functions
    override func main() {
        super.main()
        self.getPRs()
    }

}

// MARK: - Private Functions
private extension SyncPRsOperation {
    
    func getPRs(){
        self.subscription = GithubAPI().pullRequests().sink(
            receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorCB(error)
                }
                self?.done()
            },
            receiveValue: { [weak self] results in
                try? self?.gitHubPREntityService.createAllPRs(entities: results.map { $0.toEntity() })
                self?.done()
            }
        )
    }
}
