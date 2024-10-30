//
//  PRListViewModel.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

final class PRListViewModel: ObservableObject {
    // MARK: - Properties
    @Published var entities: [GitHubPullRequest] = []
    @Published var repo: GitHubRepo
    @Published var navTitle: String
    @Published var error: Error?
    
    // MARK: Private
    private var prRepo: GitHubPRRepository
    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(repo: GitHubRepo, prRepo: GitHubPRRepository = GitHubPRRepositoryImpl.sharedInstance(GitHubRemoteDataSource())) {
        self.repo = repo
        self.prRepo = prRepo
        self.navTitle = "\(repo.name) \(String.localize(.openPullRequest))"
        self.searchData(repo: repo)
    }
    
    /// Refreshes all pull requests for the selected repository
    func refreshData() {
        self.error = nil
        self.searchData(repo: repo)
    }
}

// MARK: - Private Function
private extension PRListViewModel {

    /// Fetches pull requests for a given repository
    func searchData(repo: GitHubRepo) {
        self.prRepo.pullRequests(for: repo)
            .receive(on: DispatchQueue.main)
            .catch({ (error) -> Just<[GitHubPullRequest]> in
                self.error = error
                return Just([GitHubPullRequest]())
            })
            .sink(receiveValue: { [weak self] value in
                self?.entities.append(contentsOf: value)
            })
            .store(in: &cancellableSet)
    }
}
