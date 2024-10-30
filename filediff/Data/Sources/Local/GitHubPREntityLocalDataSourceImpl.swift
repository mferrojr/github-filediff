//
//  GitHubPREntityLocalDataSource.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

protocol GitHubPREntityLocalDataSource: BaseDataSource where DB == GitHubPR, Domain == GitHubPREntity  {
    func findById(_ id: Int) -> Domain?
    func fetchAll(sorted: Sorted?) -> [Domain]
}

struct GitHubPREntityLocalDataSourceImpl: GitHubPREntityLocalDataSource {
    var storageContext: StorageContext?
    
    func findById(_ id: Int) -> Domain? {
        return self.fetch(predicate: NSPredicate(format: "id = \(id)")).last
    }
    
    func fetchAll(sorted: Sorted? = nil) -> [Domain] {
        return self.fetch(predicate: nil, sorted: sorted)
    }

}
