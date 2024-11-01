//
//  SyncPRDiffOperation.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

final class SyncPRDiffOperation: BaseOperation, @unchecked Sendable {
    
    // MARK: - Properties
    
    // MARK: Private
    private var diffUrl: URL
    private var context: FileDiffQueueContext!
    private var prRepo: GitHubPRRepository
    
    // MARK: - Initialization
    required init(diffUrl : URL, context : FileDiffQueueContext, prRepo: GitHubPRRepository = GitHubPRRepositoryImpl(GitHubRemoteDataSource())) {
        self.diffUrl = diffUrl
        self.context = context
        self.prRepo = prRepo
    }
    
    // MARK: - Functions
    override func main() {
        super.main()
        getPRDiff()
    }
    
}

// MARK: - Private Functions
private extension SyncPRDiffOperation {
    
    func getPRDiff(){
        self.subscription = prRepo.pullRequestBy(diffUrl: diffUrl).sink(
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
