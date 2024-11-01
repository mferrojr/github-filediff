//
//  RepoSearchViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

enum RepoSearchViewModelError: Error {
    case invalidSearchText
}

final class RepoSearchViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var title: String = .localize(.gitHubRepositoryDiffTool)
    @Published private(set) var state: ViewState<[GitHubRepo]> = .initial
    
    // MARK: Private
    private var repo: GitHubRepoRepository
    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(repo: GitHubRepoRepository = GitHubRepoRepositoryImpl(GitHubRemoteDataSource())) {
        self.repo = repo
    }
    
    /// Searchs for repositories
    /// - Parameters:
    ///  - input: repo name to search for
    func searchRepos(with input: String) {
        do {
            self.state = .initial
            let searchText = try validate(input: input)
            self.prepareDataLoad()
            self.repo.searchRepo(by: searchText)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            self.state = .error(error)
                        }
                    },
                    receiveValue: { [weak self] in
                        self?.state = .loaded($0.items)
                    }
                )
                .store(in: &cancellableSet)
        } catch {
            // No Op
        }
    }
}

// MARK: - Private Functions
private extension RepoSearchViewModel {
    
    /// Prepare for a fresh data fetch by canceling any requests in-flight and updating state
    func prepareDataLoad() {
        self.cancellableSet.forEach { $0.cancel() }
        self.cancellableSet.removeAll()
        self.state = .loading
    }
    
    /// Validates input prior to initiating a fetch
    /// - Parameters:
    ///  - input: text to validate
    /// - Returns: true if valid or false otherwise
    /// - Throws: when input is not valid
    func validate(input: String) throws -> String {
        let searchText = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchText.isEmpty else { throw RepoSearchViewModelError.invalidSearchText }
        return searchText
    }
}
