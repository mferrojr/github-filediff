//
//  PRDiffViewModel.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/27/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

enum PRDiffViewModelError: Error {
    case invalidDiffUrl
    case filesNotFound
    case unknown
}

protocol PRDiffViewModelDelegate: AnyObject {
    func requestPRDiffCompleted(with result: Result<[GitHubFile], Error>)
    func requestPRDiffCancelled()
}

/*

final class PRDiffViewModel: ObservableObject {
    
    // MARK: Private
    private var gitHubAPIable: GitHubAPIable?
    private var diffURL: URL?
    private var cancellableSet: Set<AnyCancellable> = []
    
    private lazy var fetchDataPublisher: AnyPublisher<String, Error>? = {
        guard let diffURL = diffURL else {
            return Fail(error: PRDiffViewModelError.invalidDiffUrl)
                .eraseToAnyPublisher()
        }
        return self.gitHubAPIable?.pullRequestBy(diffUrl: diffURL)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()
    
    // MARK: - Initialization
    init(gitHubAPIable: GitHubAPIable = Services.gitHubAPIable, entity: GitHubPREntity) {
        self.gitHubAPIable = gitHubAPIable
        self.diffURL = entity.diff_url
        self.refreshData()
    }
    
    // MARK: - Functions
    func refreshData() {
        self.fetchDataPublisher?
            .catch({ (error) -> Just<String> in
                return Just(String())
            })
            .sink(receiveValue: { [weak self] value in
                GitHubParser.parse(fileText: value)
            })
            .store(in: &cancellableSet)
    }
    
}
*/

final class PRDiffViewModel {
    
    // MARK: - Properties
    weak var delegate: PRDiffViewModelDelegate?
    
    // MARK: Private
    private let queue: FileDiffQueue
    
    // MARK: - Initialization
    init() {
        self.queue = FileDiffQueue()
    }
    
    // MARK: - Functions
    
    func fetchDataFor(entity: GitHubPREntity) {
        guard let diffUrl = entity.diff_url else {
            self.delegate?.requestPRDiffCompleted(with: .failure(PRDiffViewModelError.invalidDiffUrl))
            return
        }
        
        self.queue.getFileDiff(diffUrl: diffUrl,
        completion: { result in
            switch result {
            case .success(let value):
                // UI Changes on the main queue
                DispatchQueue.main.async { [weak self] in
                    guard let files = value else {
                        self?.delegate?.requestPRDiffCompleted(with: .failure(PRDiffViewModelError.filesNotFound))
                        return
                    }
                    
                    self?.delegate?.requestPRDiffCompleted(with: .success(files))
                }
            case .error(let error):
                guard let error = error else {
                    self.delegate?.requestPRDiffCompleted(with: .failure(PRDiffViewModelError.unknown))
                    return
                }
                
                // UI Changes on the main queue
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.requestPRDiffCompleted(with: .failure(error))
                }
            }
        })
    }
    
    func cancelFetchData() {
        self.queue.cancel()
    }
}
