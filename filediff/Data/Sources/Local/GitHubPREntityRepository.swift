//
//  GitHubPREntityLocalDataSource.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

protocol GitHubPREntityRepository {
    func createAllPRs(entities: [GitHubPREntity]) throws
    func createPR(entity: GitHubPREntity) throws
    func updatePR(entity: GitHubPREntity) throws
    func fetchBy(prNumber: Int) -> GitHubPREntity?
    func fetchAll(sorted: Sorted?) -> [GitHubPREntity]
}

final class GitHubPREntityLocalDataSourceImpl<A:GitHubUserEntityDao, T:GitHubPREntityDao>: GitHubPREntityRepository {

    // MARK: - Properties
    
    // MARK: Private
    private let userDao: A
    private let prDao: T
    
    // MARK: - Initialization
    init(prDao: T, userEntityDao: A) {
        self.prDao = prDao
        self.userDao = userEntityDao
    }
    
    // MARK: - Functions
    func createAllPRs(entities: [T.Domain]) throws {
        for entity in entities {
            try self.createPR(entity: entity)
        }
    }
    
    func createPR(entity: T.Domain) throws {
        if let user = entity.user {
            entity.storable = try self.userDao.save(object: user)
        }

        _ = try self.prDao.save(object: entity)
    }
    
    func updatePR(entity: T.Domain) throws {
        try self.prDao.update(object: entity)
    }

    func fetchBy(prNumber: Int) -> T.Domain? {
        return self.prDao.findById(prNumber)
    }
    
    func fetchAll(sorted: Sorted? = nil) -> [T.Domain] {
        return self.prDao.fetchAll(sorted: sorted)
    }

}
