//
//  GitHubUserEntityLocalDataSource.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

protocol GitHubUserEntityLocalDataSource: LocalDataSource where DB == GitHubUser, Domain == GitHubUserEntity {
}

struct GitHubUserEntityLocalDataSourceImpl: GitHubUserEntityLocalDataSource {
    var storageContext: StorageContext?
}
