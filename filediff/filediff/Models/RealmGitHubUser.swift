//
//  RealmGitHubUser.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers
final class GitHubUser: Object, GitHubRealmBase, Decodable {
    
    //MARK: - Varibales
    dynamic var id = 0
    dynamic var login = ""
    dynamic var avatar_url = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatar_url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        login = try container.decode(String.self, forKey: .login)
        avatar_url = try container.decode(String.self, forKey: .avatar_url)
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var entity: GitHubUser {
        let user = GitHubUser()
        user.id = self.id
        user.login = self.login
        user.avatar_url = self.avatar_url
        return user
    }
    
}
