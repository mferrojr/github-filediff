//
//  FileDiffQueue.swift
//  filediff
//
//  Created by bn-user on 7/25/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

class FileDiffQueueContext {
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
    
    private var _fileText: String?
    private var _files: [GitHubFile]?
    private let lock = NSLock()
}

enum FileDiffQueueResult {
    case success([GitHubFile]?)
    case error(Error?)
}

class FileDiffQueue {
    
    private let queue = OperationQueue()
    
    func getFileDiff(diffUrl: String, completion : @escaping (FileDiffQueueResult) -> Void) {
        let context = FileDiffQueueContext()
        
        // Get file diff
        let prDiffOperation = SyncPRDiffOperation(diffUrl: diffUrl,context: context)
        prDiffOperation.errorCallback = { error in
            completion(.error(error))
        }
        
        // Parse the files
        let parseFilesOperation = GitHubParserOperation(context: context)
        parseFilesOperation.errorCallback = { error in
            completion(.error(error))
        }
        parseFilesOperation.completionBlock = {
           completion(.success(context.files))
        }
        parseFilesOperation.addDependency(prDiffOperation)
        
        // Add operations to queue
        queue.qualityOfService = .userInitiated
        queue.addOperation(prDiffOperation)
        queue.addOperation(parseFilesOperation)
    }
    
    func cancel() {
        queue.cancelAllOperations()
    }
    
}
