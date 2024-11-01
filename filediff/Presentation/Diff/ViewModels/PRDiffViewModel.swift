//
//  PRDiffViewModel.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

enum PRDiffViewModelError: Error, Sendable {
    case invalidDiffUrl
    case filesNotFound
    case unknown
}

@MainActor
final class PRDiffViewModel {
    
    // MARK: - Properties
    
    // MARK: Private
    private var queue: FileDiffQueue
    
    // MARK: - Initialization
    init() {
        self.queue = FileDiffQueue()
    }
    
    // MARK: - Functions
    func fetchDataFor(diffUrl: String) async -> Result<[GitHubFile], Error> {
        let result = await self.queue.getFileDiff(diffUrl: diffUrl)
        switch result {
        case .success(let value):
            guard let files = value else {
                return .failure(PRDiffViewModelError.filesNotFound)
            }
            return .success(files)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func cancelFetchData() async {
        self.queue.cancel()
    }
}
