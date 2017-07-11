//
//  GitHubObject.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Realm
import RealmSwift
import ObjectMapper

protocol GitHubRealmBase {
    var id: String { get set }
}

class GitHubObject : Object, Mappable {
    
    required init?(map: Map) {
        super.init()
    }

    required init(){
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value,schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm,schema: schema)
    }
    
    func mapping(map: Map) {
        
    }
    
}
