//
//  GitHubUserEntity.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import CoreData

final class GitHubUserEntity: DomainBaseEntity {
    
    // MARK: - Properties
    var objectID: NSManagedObjectID?
    var id: Int = 0
    var login: String?
    var avatar_url: String?
    
    // MARK: - Functions
    func populate(storable: Storable) -> Storable {
        guard let entity = storable as? GitHubUser else {
            return storable
        }
        entity.id = Int32(self.id)
        entity.login = self.login
        entity.avatar_url = self.avatar_url
        return entity
    }
}
