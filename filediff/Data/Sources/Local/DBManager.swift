//
//  DBManager.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

final class DBManager {

    // MARK: - Properties
    
    // MARK: Private
    private var storageContext: StorageContext?

    // MARK: - Initialization
    init(storageContext: StorageContext) {
        self.storageContext = storageContext
    }

    func storageContextImpl() -> StorageContext {
        if self.storageContext != nil {
            return self.storageContext!
        }
        fatalError("You must call setup to configure the StoreContext before accessing any dao")
    }

}
