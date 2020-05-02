//
//  GitHubPREntityDao.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

protocol GitHubPREntityDao: BaseDao where DB == GitHubPR, Domain == GitHubPREntity  {
    func findById(_ id: Int) -> Domain?
    func fetchAll(sorted: Sorted?) -> [Domain]
}

struct GitHubPREntityDaoService: GitHubPREntityDao {
    var storageContext: StorageContext?
    
    func findById(_ id: Int) -> Domain? {
        return self.fetch(predicate: NSPredicate(format: "id = \(id)")).last
    }
    
    func fetchAll(sorted: Sorted? = nil) -> [Domain] {
        return self.fetch(predicate: nil, sorted: sorted)
    }

}
