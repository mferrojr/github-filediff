//
//  GitHubPREntityService.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

class GitHubPREntityService {

    func createAllPRs(entities: [GitHubPREntity]) throws {
        for entity in entities {
            try self.createPR(entity: entity)
        }
    }
    
    func createPR(entity: GitHubPREntity) throws {
        if let user = entity.user {
            entity.storable = try DBManager.shared.gitHubUserDao.save(object: user)
        }

        _ = try DBManager.shared.gitHubPRDao.save(object: entity)
    }
    
    func updatePR(entity: GitHubPREntity) throws {
        try DBManager.shared.gitHubPRDao.update(object: entity)
    }

    func fetchBy(prNumber: Int) -> GitHubPREntity? {
        return DBManager.shared.gitHubPRDao.findById(prNumber)
    }
    
    func fetchAll() -> [GitHubPREntity] {
        return DBManager.shared.gitHubPRDao.fetchAll()
    }

}
