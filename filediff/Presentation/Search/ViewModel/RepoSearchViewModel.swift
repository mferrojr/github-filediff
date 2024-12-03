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

struct RepoByLetterItem: Identifiable, Equatable {
    let id: String
    let repos: [GitHubRepo]
}

final class RepoSearchViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var title: String = "GitHub Repository Diff Tool"
    @Published private(set) var state: ViewState<[RepoByLetterItem]> = .initial
    
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
                        self?.state = .loaded(self?.parse(repos: $0.items) ?? [])
                    }
                )
                .store(in: &cancellableSet)
        } catch {
            self.state = .error(error)
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
    
    /// Parse GitHubRepo for view display. Each section is the first letter of `fullName`
    /// - Parameters:
    ///  - repos: GitHub repositories
    /// - Returns: array of GitHubRepoItems for display
    func parse(repos: [GitHubRepo]) -> [RepoByLetterItem]{
        let reposByLetter = repoByLetter(of: repos)
        var results: [RepoByLetterItem] = []
        for letter in reposByLetter.keys.sorted() {
            guard let repos = reposByLetter[letter] else { continue }
            results.append(.init(id: letter, repos: repos.sorted(by: {$0.fullName < $1.fullName })))
        }
        return results
    }
    
    /// For all returned repositories, map first letter of `fullName` to array of corresponding repos
    /// - Parameters:
    ///  - repos: GitHub repositories
    /// - Returns: dictionary of letter to repositories
    func repoByLetter(of repos: [GitHubRepo]) -> [String:[GitHubRepo]] {
        var firstCharacters = [String:[GitHubRepo]]()
        for repo in repos {
            guard let firstLetter = repo.fullName.first?.uppercased() else { continue }
            if let _ = firstCharacters[firstLetter] {
                firstCharacters[firstLetter]?.append(repo)
            } else {
                firstCharacters[firstLetter] = [repo]
            }
        }
        return firstCharacters
    }
}
