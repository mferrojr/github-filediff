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
    @Published var navTitle: String
    @Published var state: ViewState<[GitHubPullRequest]> = .initial
    private var repo: GitHubRepo
    
    // MARK: Private
    private var prRepo: GitHubPRRepository
    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(repo: GitHubRepo,
         prRepo: GitHubPRRepository = GitHubPRRepositoryImpl(GitHubRemoteDataSource())
    ) {
        self.repo = repo
        self.prRepo = prRepo
        self.navTitle = "\(repo.name) \(String.localize(.openPullRequest))"
    }
    
    /// Refreshes all pull requests for the selected repository
    func refreshData() {
        self.prepareDataLoad()
        self.searchData()
    }
}

// MARK: - Private Function
private extension PRListViewModel {

    /// Fetches pull requests for a given repository
    func searchData() {
        self.prRepo.pullRequests(for: repo)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.state = .error(error)
                    }
                },
                receiveValue: { [weak self] in
                    self?.state = .loaded($0)
                }
            )
            .store(in: &cancellableSet)
    }
    
    /// Prepare for a fresh data fetch by canceling any requests in-flight and updating state
    func prepareDataLoad() {
        self.cancellableSet.forEach { $0.cancel() }
        self.cancellableSet.removeAll()
        self.state = .loading
    }
}
