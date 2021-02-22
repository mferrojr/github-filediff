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

protocol PRListViewModelDelegate: AnyObject {
    func requestPRsCompleted(with result: Result<Void, Error>)
    func requestPRsCancelled()
}

final class PRListViewModel {
    
    // MARK: - Properties
    weak var delegate: PRListViewModelDelegate?
    
    // MARK: Private
    private var prOperation: SyncPRsOperation?
    private var subscriptions = Set<AnyCancellable?>()
    private let queue: OperationQueue
    
    // MARK: - Initialization
    init() {
        self.queue = OperationQueue()
        self.queue.qualityOfService = .userInitiated
    }
    
    // MARK: - Functions
    func fetchData() {
        self.prOperation = SyncPRsOperation(prService: Services.prEntityService)
        self.subscriptions.insert(self.prOperation?.subscription)
        self.prOperation?.completionBlock = { [weak self] in
            self?.prOperation = nil
            
            // UI Changes on the main queue
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.requestPRsCompleted(with: .success(()))
            }
        }
        self.prOperation?.errorCallback = { error in
            guard let error = error else {
                self.delegate?.requestPRsCompleted(with: .failure(PRListViewModelError.unknown))
                return
            }
            
            // UI Changes on the main queue
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.requestPRsCompleted(with: .failure(error))
            }
        }
        
        guard let op = self.prOperation else { return }
        self.queue.addOperation(op)
    }
    
    func cancelFetchData() {
        self.delegate?.requestPRsCancelled()
        self.subscriptions.forEach { $0?.cancel() }
        self.prOperation?.cancel()
        self.prOperation = nil
    }
}
