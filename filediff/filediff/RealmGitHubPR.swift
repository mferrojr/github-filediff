//
//  RealmGitHubPR.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import ObjectMapper
import RealmSwift

struct GitHubPR {
    var id = ""
    var number = 0
    var state = ""
    var title = ""
    var created_at = ""
    var user : GitHubUser?
}

final class RealmGitHubPR : GitHubObject, GitHubRealmBase {
    
    //MARK: - Varibales
    dynamic var id = ""
    dynamic var number = 0
    dynamic var state = ""
    dynamic var title = ""
    dynamic var created_at = ""
    dynamic var user : RealmGitHubUser?
    
    override func mapping(map: Map) {
        id <- map["id"]
        number <- map["number"]
        state <- map["state"]
        title <- map["title"]
        created_at <- map["created_at"]
        user <- map["user"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var entity: GitHubPR {
        return GitHubPR(id: title,
                    number: number,
                    state: state,
                    title: title,
                    created_at: created_at,
                    user: user?.entity)
    }
    
}
