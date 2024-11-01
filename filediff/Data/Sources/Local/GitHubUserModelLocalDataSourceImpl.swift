//
//  GitHubUserEntityLocalDataSource.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

protocol GitHubUserModelLocalDataSource: LocalDataSource where DB == GitHubUser, Domain == GitHubUserModel {
}

struct GitHubUserModelLocalDataSourceImpl: GitHubUserModelLocalDataSource {
    var storageContext: StorageContext?
}
