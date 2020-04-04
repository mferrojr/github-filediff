//
//  GitHubPREntity.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import CoreData

class GitHubPREntity: DomainBaseEntity, HasStorable {
    var storable: Storable?
    var objectID: NSManagedObjectID?
    var id: Int = 0
    var number: Int = 0
    var diff_url: String?
    var state: String?
    var title: String?
    var body: String?
    var created_at: String?
    var user: GitHubUserEntity?
    
    func populate(storable: Storable) -> Storable {
        guard let entity = storable as? GitHubPR else {
            return storable
        }
        
        entity.body = self.body
        entity.created_at = self.created_at
        entity.diff_url = self.diff_url
        entity.id = Int32(self.id)
        entity.number = Int32(self.number)
        entity.state = self.state
        entity.title = self.title
        if let userDb = self.storable as? GitHubUser {
            entity.user = userDb
        }

        return entity
    }
}
