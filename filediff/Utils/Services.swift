//
//  Services.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 5/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

final class Services {
    
    static let coreDataStorageContext: StorageContext = CoreDataStorageContext()
    static let userEntityDao = GitHubUserEntityDaoService(storageContext: coreDataStorageContext)
    static let prEntityDao = GitHubPREntityDaoService(storageContext: coreDataStorageContext)
    static let prEntityService = GitHubPREntityService(prDao: prEntityDao, userEntityDao: userEntityDao)
    static let gitHubAPIable: GitHubAPIable = GithubAPI()
    
}
