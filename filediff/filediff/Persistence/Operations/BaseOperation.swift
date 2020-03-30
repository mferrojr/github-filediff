//
//  BaseOperation.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import RealmSwift

class BaseOperation : Operation {
    
    var errorCallback: ((Error?) -> Void)?
    var dataTask : URLSessionDataTask?
    
    //MARK: - Private Variables
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
    
    //MARK: Persistence Functions
    func saveArrayToRealm<T>(_ data : [T]?) where T:Object, T:GitHubRealmBase {
        guard let data = data, !self.isCancelled else {
            done()
            return
        }

        autoreleasepool {
            do {
                // Get the default Realm
                let realm = try Realm()
                
                try realm.write {
                    // Save list to realm
                    realm.add(data, update: .all)
                    
                    // First assume we are clearing all
                    var datas = realm.objects(T.self)
                    
                    // If there are existings datas, only delete the ones no longer in list
                    if data.count > 0 {
                        datas = datas.filter("NOT (id IN %@)", data.getIds())
                    }
                    
                    realm.delete(datas)
                }
            } catch {
                print("Error saving data for \(self.name!)")
            }
        }
        
        done()
    }
    
    func saveToRealm<T>(_ data : T?) where T:Object, T:GitHubRealmBase {
        guard let data = data, !self.isCancelled else {
            done()
            return
        }
        
        autoreleasepool {
            do {
                // Get the default Realm
                let realm = try Realm()
                
                // Add/Update
                try realm.write {
                    realm.add(data, update: .all)
                }
            } catch {
                print("Error saving data for \(self.name!)")
            }
        }
        
        done()
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
