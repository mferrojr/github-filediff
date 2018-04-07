//
//  RealmGitHubUser.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import ObjectMapper
import RealmSwift

struct GitHubUser {
    var id = 0
    var login = ""
    var avatar_url = ""
}
final class RealmGitHubUser : GitHubObject, GitHubRealmBase {
    
    //MARK: - Varibales
    @objc dynamic var id = 0
    @objc dynamic var login = ""
    @objc dynamic var avatar_url = ""
    
    override func mapping(map: Map) {
        id <- map["id"]
        login <- map["login"]
        avatar_url <- map["avatar_url"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var entity: GitHubUser {
        return GitHubUser(id: id,login: login,avatar_url: avatar_url)
    }
    
}
