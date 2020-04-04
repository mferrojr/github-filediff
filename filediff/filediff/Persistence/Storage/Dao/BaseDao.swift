//
//  BaseDao.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

class BaseDao<DomainEntity: Mappable, DBEntity: Storable> {

    private var storageContext: StorageContext?

    required init(storageContext: StorageContext) {
        self.storageContext = storageContext
    }

    func create() -> Mappable? {
        let dbEntity: DBEntity? = storageContext?.create(DBEntity.self)
        return mapToDomain(dbEntity: dbEntity!)
    }

    func save<DomainEntity: Mappable>(object: DomainEntity) throws -> DBEntity? {
        var dbEntity: DBEntity?
        if object.objectID != nil {
            dbEntity = storageContext?.objectWithObjectId(objectId: object.objectID!)
        } else {
            dbEntity = storageContext?.create(DBEntity.self)
        }

        guard let dbObject = dbEntity else { return nil }
        let storable = object.populate(storable: dbObject)
        try storageContext?.save(object: storable)
        return storable as? DBEntity
    }

    func saveAll<DomainEntity: Mappable>(objects: [DomainEntity]) throws -> [DBEntity?] {
        var dbEntities = [DBEntity?]()
        for domainEntity in objects {
            dbEntities.append(try self.save(object: domainEntity))
        }
        return dbEntities
    }

    func update<DomainEntity: Mappable>(object: DomainEntity) throws {
        guard object.objectID != nil else { return }
        
        let dbEntity: DBEntity? = storageContext?.objectWithObjectId(objectId: object.objectID!)
        guard let dbObject = dbEntity else { return }
        let storable = object.populate(storable: dbObject)
        try storageContext?.update(object: storable)
    }

    func delete<DomainEntity: Mappable>(object: DomainEntity) throws {
        if object.objectID != nil {
            let dbEntity: DBEntity? = storageContext?.objectWithObjectId(objectId: object.objectID!)
            try storageContext?.delete(object: dbEntity!)
        }
    }

    func deleteAll() throws {
        try storageContext?.deleteAll(DBEntity.self)
    }

    func fetch(predicate: NSPredicate?, sorted: Sorted? = nil) -> [DomainEntity] {
       let dbEntities = storageContext?.fetch(DBEntity.self, predicate: predicate, sorted: sorted) as? [DBEntity]
       return mapToDomain(dbEntities: dbEntities)
    }

    private func mapToDomain<DBEntity: Storable>(dbEntity: DBEntity) -> DomainEntity {
        return dbEntity.toMappable() as! DomainEntity
    }

    private func mapToDomain<DBEntity: Storable>(dbEntities: [DBEntity]?) -> [DomainEntity] {
       var domainEntities = [DomainEntity]()
       for dbEntity in dbEntities! {
           domainEntities.append(mapToDomain(dbEntity: dbEntity))
       }
       return domainEntities
    }
}
