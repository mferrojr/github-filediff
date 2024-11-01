//
//  GitHubPREntityRepository.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

protocol GitHubPRModelRepository {
    func createAllPRs(entities: [GitHubPRModel]) throws
    func createPR(entity: GitHubPRModel) throws
    func updatePR(entity: GitHubPRModel) throws
    func fetchBy(prNumber: Int) -> GitHubPRModel?
    func fetchAll(sorted: Sorted?) -> [GitHubPRModel]
}

final class GitHubPRModelRepositoryImpl<A:GitHubUserModelLocalDataSource, T:GitHubPREntityLocalDataSource>: GitHubPRModelRepository {

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
