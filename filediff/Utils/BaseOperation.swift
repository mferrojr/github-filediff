//
//  BaseOperation.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import Combine

class BaseOperation: Operation, @unchecked Sendable {
    
    // MARK: - Properties
    
    // MARK: Public
    var errorCallback: ((Error?) -> Void)?
    var dataTask : URLSessionDataTask?
    var subscription: AnyCancellable?
    
    // MARK: Private
    fileprivate var _executing = false
    override var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            if _executing != newValue {
                willChangeValue(forKey: "isExecuting")
                _executing = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    fileprivate var _finished = false
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func cancel() {
        guard !self.isCancelled else { return }
        
        completionBlock = nil
        dataTask?.cancel()
    }

    //MARK: Ending Functions
    func done() {
        isExecuting = false
        isFinished = true
    }
    
    func errorCB(_ error : Error?) {
        self.errorCallback?(error)
    }

}
