//
//  GitHubUserEntityDao.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/4/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

protocol GitHubUserEntityDao: BaseDao where DB == GitHubUser, Domain == GitHubUserEntity {
}

struct GitHubUserEntityDaoService: GitHubUserEntityDao {
    var storageContext: StorageContext?
}
