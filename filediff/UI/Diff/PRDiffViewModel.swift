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

protocol PRDiffViewModelDelegate: class {
    func requestPRDiffCompleted(with result: Result<[GitHubFile], Error>)
    func requestPRDiffCancelled()
}

class PRDiffViewModel {
    
    // MARK: - Variables
    
    // MARK: Public
    weak var delegate: PRDiffViewModelDelegate?
    
    // MARK: Private
    private let queue: FileDiffQueue
    
    // MARK: - Initialization
    init() {
        self.queue = FileDiffQueue()
    }
    
    // MARK: - Functions
    
    // MARK: Public
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
