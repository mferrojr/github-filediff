//
//  Repository.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import RealmSwift

protocol Repository {
    associatedtype T
    
    func getAll() -> [T]
    func getById(id: Int) -> T?
    func insert(item: T)
    func update(item: T)
    func deleteById(id: String)
    
}
