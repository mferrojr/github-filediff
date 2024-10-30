//
//  GitHubUser+CoreDataClass.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//
//

import Foundation
import CoreData

public class GitHubUser: NSManagedObject {
}

extension GitHubUser: Storable {
    
    func toMappable() -> Mappable {
        let entity = GitHubUserEntity()
        entity.objectID = self.objectID
        entity.id = Int(self.id)
        entity.login = self.login
        entity.avatar_url = self.avatar_url
        return entity
    }
}
