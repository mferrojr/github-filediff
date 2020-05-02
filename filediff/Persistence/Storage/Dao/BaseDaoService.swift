//
//  BaseDao.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

protocol BaseDao {
    associatedtype Domain: Mappable
    associatedtype DB: Storable
    
    var storageContext: StorageContext? { get set }
    
    func create() -> Domain?
    func save(object: Domain) throws -> DB?
    func saveAll(objects: [Domain]) throws -> [DB?]
    func update(object: Domain) throws
    func delete(object: Domain) throws
    func deleteAll() throws
    func fetch(predicate: NSPredicate?, sorted: Sorted?) -> [Domain]
}

extension BaseDao {
    
    // MARK: - Functions
    
    // MARK: Public
    func create() -> Domain? {
        let dbEntity: DB? = storageContext?.create(DB.self)
        return mapToDomain(dbEntity: dbEntity!)
    }
    
    func save(object: Domain) throws -> DB? {
        var dbEntity: DB?
        if object.objectID != nil {
            dbEntity = storageContext?.objectWithObjectId(objectId: object.objectID!)
        } else {
            dbEntity = storageContext?.create(DB.self)
        }

        guard let dbObject = dbEntity else { return nil }
        let storable = object.populate(storable: dbObject)
        try storageContext?.save(object: storable)
        return storable as? DB
    }
    
    func saveAll(objects: [Domain]) throws -> [DB?] {
        var dbEntities = [DB?]()
        for domainEntity in objects {
            dbEntities.append(try self.save(object: domainEntity))
        }
        return dbEntities
    }
    
    func update(object: Domain) throws {
        guard object.objectID != nil else { return }
        
        let dbEntity: DB? = storageContext?.objectWithObjectId(objectId: object.objectID!)
        guard let dbObject = dbEntity else { return }
        let storable = object.populate(storable: dbObject)
        try storageContext?.update(object: storable)
    }
    
    func delete(object: Domain) throws {
        if object.objectID != nil {
            let dbEntity: DB? = storageContext?.objectWithObjectId(objectId: object.objectID!)
            try storageContext?.delete(object: dbEntity!)
        }
    }
    
    func deleteAll() throws {
        try storageContext?.deleteAll(DB.self)
    }
    
    func fetch(predicate: NSPredicate?, sorted: Sorted? = nil) -> [Domain] {
        let dbEntities = storageContext?.fetch(DB.self, predicate: predicate, sorted: sorted) as? [DB]
        return mapToDomain(dbEntities: dbEntities)
    }
    
    // MARK: Private
    private func mapToDomain(dbEntity: DB) -> Domain {
        return dbEntity.toMappable() as! Domain
    }

    private func mapToDomain(dbEntities: [DB]?) -> [Domain] {
       var domainEntities = [Domain]()
       for dbEntity in dbEntities! {
           domainEntities.append(mapToDomain(dbEntity: dbEntity))
       }
       return domainEntities
    }
    
}

class BaseDaoService<DomainEntity: Mappable, DBEntity: Storable>: BaseDao {
    
    typealias Domain = DomainEntity
    typealias DB = DBEntity
    
    // MARK: - Variables
    
    // MARK: Private
    internal var storageContext: StorageContext?

    // MARK: - Initialization
    init(storageContext: StorageContext) {
        self.storageContext = storageContext
    }
    
    // MARK: - Functions
    
    // MARK: Public
    func create() -> DomainEntity? {
        let dbEntity: DBEntity? = storageContext?.create(DBEntity.self)
        return mapToDomain(dbEntity: dbEntity!)
    }
    
    func save(object: DomainEntity) throws -> DBEntity? {
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
    
    func saveAll(objects: [DomainEntity]) throws -> [DBEntity?] {
        var dbEntities = [DBEntity?]()
        for domainEntity in objects {
            dbEntities.append(try self.save(object: domainEntity))
        }
        return dbEntities
    }
    
    func update(object: DomainEntity) throws {
        guard object.objectID != nil else { return }
        
        let dbEntity: DBEntity? = storageContext?.objectWithObjectId(objectId: object.objectID!)
        guard let dbObject = dbEntity else { return }
        let storable = object.populate(storable: dbObject)
        try storageContext?.update(object: storable)
    }
    
    func delete(object: DomainEntity) throws {
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
    
    // MARK: Private
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

