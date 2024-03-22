//
//  Services.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 5/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

final class Services: @unchecked Sendable {
    let coreDataStorageContext: StorageContext
    let userEntityDao: GitHubUserEntityDaoService
    let prEntityDao: GitHubPREntityDaoService
    let prEntityService: GitHubPREntityService<GitHubUserEntityDaoService, GitHubPREntityDaoService>
    let gitHubAPIable: GitHubAPIable
    
    static let shared = Services()
    
    private init() {
        coreDataStorageContext = CoreDataStorageContext()
        userEntityDao = GitHubUserEntityDaoService(storageContext: coreDataStorageContext)
        prEntityDao = GitHubPREntityDaoService(storageContext: coreDataStorageContext)
        prEntityService = GitHubPREntityService(prDao: prEntityDao, userEntityDao: userEntityDao)
        gitHubAPIable = GithubAPI()
    }
}
