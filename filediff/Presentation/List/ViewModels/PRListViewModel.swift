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
    @Published var entities: [GitHubPREntity] = []
    @Published var repo: GitHubRepoEntity
    
    // MARK: Private
    private var services: Services?
    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(repo: GitHubRepoEntity, entities: [GitHubPREntity]) {
        self.repo = repo
        self.entities = entities
    }
    
    init(repo: GitHubRepoEntity, services: Services = .shared) {
        self.repo = repo
        self.services = services
        self.searchData(repo: repo)
    }
    
    /// Refreshes all pull requests for the selected repository
    func refreshData() {
        self.searchData(repo: repo)
    }
}

// MARK: - Private Function
private extension PRListViewModel {

    /// Fetches pull requests for a given repository
    func searchData(repo: GitHubRepoEntity) {
        self.services?.gitHubAPIable.pullRequests(for: repo)
            .receive(on: DispatchQueue.main)
            .catch({ (error) -> Just<[GitHubPRResponse]> in
                return Just([GitHubPRResponse]())
            })
            .map { responses -> [GitHubPREntity] in
                responses.map { $0.toEntity() }
            }
            .sink(receiveValue: { [weak self] value in
                self?.entities.append(contentsOf: value)
            })
            .store(in: &cancellableSet)
    }
}
