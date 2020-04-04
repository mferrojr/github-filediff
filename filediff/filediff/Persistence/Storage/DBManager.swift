//
//  DBManager.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

class DBManager {

    // MARK: - Private properties
    private var storageContext: StorageContext?

    // MARK: - Public properties
    static var shared = DBManager()

    lazy var gitHubPRDao = GitHubPREntityDao(storageContext: storageContextImpl())
    lazy var gitHubUserDao = GitHubUserEntityDao(storageContext: storageContextImpl())

    private init() {
    }

    static func setup(storageContext: StorageContext) {
        shared.storageContext = storageContext
    }

    private func storageContextImpl() -> StorageContext {
        if self.storageContext != nil {
            return self.storageContext!
        }
        fatalError("You must call setup to configure the StoreContext before accessing any dao")
    }

}
