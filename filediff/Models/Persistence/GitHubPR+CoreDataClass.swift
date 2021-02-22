//
//  GitHubPR+CoreDataClass.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 3/30/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//
//

import Foundation
import CoreData

public class GitHubPR: NSManagedObject {
}

extension GitHubPR: Storable {
    
    func toMappable() -> Mappable {
        let entity = GitHubPREntity()
        entity.objectID = self.objectID
        entity.body = self.body
        entity.created_at = self.created_at
        entity.diff_url = self.diff_url
        entity.id = Int(self.id)
        entity.number = Int(self.number)
        entity.state = self.state
        entity.title = self.title
        entity.user = self.user?.toMappable() as? GitHubUserEntity
        return entity
    }

}
