//
//  PRListViewModel.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/27/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

enum PRListViewModelError: Error {
    case unknown
}

protocol PRListViewModelDelegate: class {
    func requestPRsCompleted(with result: Result<Void, Error>)
    func requestPRsCancelled()
}

class PRListViewModel {
    
    // MARK: - Variables
    
    // MARK: Public
    weak var delegate: PRListViewModelDelegate?
    
    // MARK: Private
    private var prOperation: SyncPRsOperation?
    private var subscriptions = Set<AnyCancellable?>()
    private let queue: OperationQueue
    
    // MARK: - Initialization
    init() {
        queue = OperationQueue()
        queue.qualityOfService = .userInitiated
    }
    
    // MARK: - Functions
    
    // MARK: Public
    func fetchData() {
        prOperation = SyncPRsOperation()
        self.subscriptions.insert(prOperation?.subscription)
        prOperation?.completionBlock = { [unowned self] in
            self.prOperation = nil
            
            // UI Changes on the main queue
            DispatchQueue.main.async { [unowned self] in
                self.delegate?.requestPRsCompleted(with: .success(()))
            }
        }
        prOperation?.errorCallback = { error in
            guard let error = error else {
                self.delegate?.requestPRsCompleted(with: .failure(PRListViewModelError.unknown))
                return
            }
            
            // UI Changes on the main queue
            DispatchQueue.main.async { [unowned self] in
                self.delegate?.requestPRsCompleted(with: .failure(error))
            }
        }
        
        guard let op = prOperation else { return }
        queue.addOperation(op)
    }
    
    func cancelFetchData() {
        self.delegate?.requestPRsCancelled()
        self.prOperation?.cancel()
        self.prOperation = nil
    }
    
    // MARK: Private
}
