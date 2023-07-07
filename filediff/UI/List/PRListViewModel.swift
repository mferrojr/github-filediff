//
//  PRListViewModel.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/27/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

final class PRListViewModel: ObservableObject {
    // MARK: - Properties
    @Published var entities: [GitHubPREntity] = []
    @Published var title: String = "Welcome"
    
    // MARK: Private
    private var gitHubAPIable: GitHubAPIable?
    private var cancellableSet: Set<AnyCancellable> = []
    
    private lazy var fetchDataPublisher: AnyPublisher<[GitHubPRResponse], Error>? = {
        self.gitHubAPIable?.pullRequests()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()
    
    // MARK: - Initialization
    init(title: String, entities: [GitHubPREntity]) {
        self.title = title
        self.entities = entities
    }
    
    init(gitHubAPIable: GitHubAPIable = Services.gitHubAPIable) {
        self.gitHubAPIable = gitHubAPIable
        self.refreshData()
    }
    
    // MARK: - Functions
    func refreshData() {
        self.fetchDataPublisher?
            .catch({ (error) -> Just<[GitHubPRResponse]> in
                return Just([GitHubPRResponse]())
            })
            .map { responses -> [GitHubPREntity] in
                responses.map { $0.toEntity() }
            }
            .assign(to: \.entities, on: self)
            .store(in: &cancellableSet)
    }
}
