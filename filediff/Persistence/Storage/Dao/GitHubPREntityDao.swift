//
//  GitHubPREntityDao.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

class GitHubPREntityDao: BaseDao<GitHubPREntity, GitHubPR> {

    func findById(_ id: Int) -> GitHubPREntity? {
        return super.fetch(predicate: NSPredicate(format: "id = \(id)")).last
    }
    
    func fetchAll(sorted: Sorted? = nil) -> [GitHubPREntity] {
        return super.fetch(predicate: nil, sorted: sorted)
    }

}
