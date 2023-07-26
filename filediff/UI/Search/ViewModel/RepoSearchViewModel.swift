//
//  RepoSearchViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 7/25/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

final class RepoSearchViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var items: [GitHubRepoEntity] = []
    @Published var title: String = .localize(.gitHubRepositoryDiffTool)
    
    // MARK: Private
    private var gitHubAPIable: GitHubAPIable?
    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(title: String, entities: [GitHubRepoEntity]) {
        self.title = title
        self.items = entities
    }
    
    init(gitHubAPIable: GitHubAPIable = Services.gitHubAPIable) {
        self.gitHubAPIable = gitHubAPIable
    }
    
    /// Searchs for repositories
    /// - Parameters:
    ///  - input: repo name to search for
    func searchRepos(with input: String) {
        self.items.removeAll()
        
        self.gitHubAPIable?.searchRepo(by: input)
            .receive(on: DispatchQueue.main)
            .catch({ (error) -> Just<GitHubSearchResponse> in
                return Just(GitHubSearchResponse())
            })
            .map { response -> [GitHubRepoEntity] in
                response.items.map { $0.toEntity() }
            }
            .sink(receiveValue: { [weak self] value in
                self?.items.append(contentsOf: value)
            })
            .store(in: &cancellableSet)
    }
}
