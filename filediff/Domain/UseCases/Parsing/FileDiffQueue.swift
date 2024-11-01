//
//  FileDiffQueue.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

final class FileDiffQueueContext: @unchecked Sendable {
    
    // MARK: - Properties
    
    // MARK: Private
    private var _fileText: String?
    private var _files: [GitHubFile]?
    private let lock = NSLock()
    
    var fileText: String? {
        set {
            lock.lock()
            self._fileText = newValue
            lock.unlock()
        }
        get {
            lock.lock()
            let result =  self._fileText
            lock.unlock()
            return result
        }
    }
    var files: [GitHubFile]? {
        set {
            lock.lock()
            self._files = newValue
            lock.unlock()
        }
        get {
            lock.lock()
            let result =  self._files
            lock.unlock()
            return result
        }
    }
}

enum FileDiffQueueResultError: Error {
    case malformedUrl
    case unknown
}

enum FileDiffQueueResult {
    case success([GitHubFile]?)
    case error(Error?)
}

final class FileDiffQueue: Sendable {
    
    // MARK: - Properties
    
    // MARK: Private
    private let queue = OperationQueue()
    
    // MARK: - Functions
    func getFileDiff(diffUrl: String) async -> Result<[GitHubFile]?, Error> {
        guard let url = URL(string: diffUrl) else {
            return .failure(FileDiffQueueResultError.malformedUrl)
        }
        
        let context = FileDiffQueueContext()
        let prDiffOperation = SyncPRDiffOperation(diffUrl: url, context: context)
        return await withCheckedContinuation { continuation in
            prDiffOperation.errorCallback = { error1 in
                continuation.resume(returning: .failure(error1 ?? FileDiffQueueResultError.unknown))
            }
            // Parse the files
            let parseFilesOperation = GitHubParserOperation(context: context)
            parseFilesOperation.errorCallback = { error2 in
                continuation.resume(returning: .failure(error2 ?? FileDiffQueueResultError.unknown))
            }
            parseFilesOperation.completionBlock = {
                continuation.resume(returning: .success(context.files))
            }
            parseFilesOperation.addDependency(prDiffOperation)
            
            // Add operations to queue
            self.queue.qualityOfService = .userInitiated
            self.queue.addOperation(prDiffOperation)
            self.queue.addOperation(parseFilesOperation)
        }
    }
    
    func cancel() {
        self.queue.cancelAllOperations()
    }
}
