//
//  RepoSearchViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

final class RepoSearchViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var items: [GitHubRepo] = []
    @Published var title: String = .localize(.gitHubRepositoryDiffTool)
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    // MARK: Private
    private var repo: GitHubRepoRepository
    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(repo: GitHubRepoRepository = GitHubRepoRepositoryImpl.sharedInstance(GitHubRemoteDataSource())) {
        self.repo = repo
    }
    
    /// Searchs for repositories
    /// - Parameters:
    ///  - input: repo name to search for
    func searchRepos(with input: String) {
        self.cancellableSet.forEach { $0.cancel() }
        self.cancellableSet.removeAll()
        self.error = nil
        self.isLoading = true
        
        self.repo.searchRepo(by: input)
            .receive(on: DispatchQueue.main)
            .catch({ (error) -> Just<GitHubSearch> in
                self.error = error
                return Just(GitHubSearch(items: []))
            })
            .sink(receiveValue: { [weak self] value in
                self?.isLoading = false
                self?.items.removeAll()
                self?.items = value.items
            })
            .store(in: &cancellableSet)
    }
}
