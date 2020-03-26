//
//  RealmGitHubPR.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers
final class GitHubPR: Object, GitHubRealmBase, Decodable {
    
    //MARK: - Varibales
    dynamic var id = 0
    dynamic var number = 0
    dynamic var diff_url = ""
    dynamic var state = ""
    dynamic var title = ""
    dynamic var body = ""
    dynamic var created_at = ""
    dynamic var user: GitHubUser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case number
        case diff_url
        case state
        case title
        case body
        case created_at
        case user
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        number = try container.decode(Int.self, forKey: .number)
        diff_url = try container.decode(String.self, forKey: .diff_url)
        state = try container.decode(String.self, forKey: .state)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        created_at = try container.decode(String.self, forKey: .created_at)
        
        user = try container.decode(GitHubUser.self, forKey: .user)
        
        super.init()
    }

    override static func primaryKey() -> String? {
        return "id"
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
    
    var entity: GitHubPR {
        let pr = GitHubPR()
        pr.id = self.id
        pr.number = self.number
        pr.diff_url = self.diff_url
        pr.state = self.state
        pr.title = self.title
        pr.created_at = self.created_at
        pr.body = self.body
        pr.user = self.user?.entity
        return pr
    }
    
}
