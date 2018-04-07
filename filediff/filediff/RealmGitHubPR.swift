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
    var id = 0
    var number = 0
    var diff_url = ""
    var state = ""
    var title = ""
    var created_at = ""
    var body = ""
    var user : GitHubUser?
}

final class RealmGitHubPR : GitHubObject, GitHubRealmBase {
    
    //MARK: - Varibales
    @objc dynamic var id = 0
    @objc dynamic var number = 0
    @objc dynamic var diff_url = ""
    @objc dynamic var state = ""
    @objc dynamic var title = ""
    @objc dynamic var body = ""
    @objc dynamic var created_at = ""
    @objc dynamic var user : RealmGitHubUser?
    
    override func mapping(map: Map) {
        id <- map["id"]
        number <- map["number"]
        diff_url <- map["diff_url"]
        state <- map["state"]
        title <- map["title"]
        body <- map["body"]
        created_at <- map["created_at"]
        user <- map["user"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var entity: GitHubPR {
        return GitHubPR(id: id,
                    number: number,
                    diff_url: diff_url,
                    state: state,
                    title: title,
                    created_at: created_at,
                    body: body,
                    user: user?.entity)
    }
    
}
