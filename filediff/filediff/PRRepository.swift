//
//  PRRepository.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import RealmSwift

class PRRepository: Repository {
    
    private let realm : Realm!
    
    init(_ realm : Realm) {
        self.realm = realm
    }
    
    func getAll() -> [GitHubPR] {
        return realm.objects(RealmGitHubPR.self).map { $0.entity }
    }
    
    func getById(id: Int) -> GitHubPR? {
        return realm.objects(RealmGitHubPR.self).filter("id == %@", id).first?.entity
    }
    
    func insert(item: GitHubPR) {
        //TODO
    }
    
    func update(item: GitHubPR) {
        //TODO
    }
    
    func deleteById(id: String) {
        //TODO
    }
    
}
