//
//  CoreDataStorageContext.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStorageContext: StorageContext {

    var managedContext: NSManagedObjectContext?

    required init(configuration: ConfigurationType = .basic(identifier: "filediff")) {
        switch configuration {
        case .basic:
            initDB(modelName: configuration.identifier, storeType: .sqLiteStoreType)
        case .inMemory:
            initDB(storeType: .inMemoryStoreType)
        }
    }
}

extension CoreDataStorageContext {

    func create<DBEntity: Storable>(_ model: DBEntity.Type) -> DBEntity? {
        let entityDescription =  NSEntityDescription.entity(forEntityName: String.init(describing: model.self),
                                                            in: managedContext!)
        let entity = NSManagedObject(entity: entityDescription!,
                                     insertInto: managedContext)
        return entity as? DBEntity
    }

    func save(object: Storable) throws {
    }

    func saveAll(objects: [Storable]) throws {
    }

    func update(object: Storable) throws {
    }

    func delete(object: Storable) throws {
    }

    func deleteAll(_ model: Storable.Type) throws {
    }

    func fetch(_ model: Storable.Type, predicate: NSPredicate?, sorted: Sorted?) -> [Storable] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String.init(describing: model.self))

        fetchRequest.predicate = predicate
        if let sorted = sorted {
            let sort = NSSortDescriptor(key: sorted.key, ascending: sorted.ascending)
            fetchRequest.sortDescriptors = [sort]
        }
        
        var results = [Storable]()
        do {
            results = try (managedContext!.fetch(fetchRequest) as? [Storable])!
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return results
    }

    func objectWithObjectId<DBEntity: Storable>(objectId: NSManagedObjectID) -> DBEntity? {
        do {
            let result = try managedContext!.existingObject(with: objectId)
            return result as? DBEntity
        } catch {
            print("Failure")
        }

        return nil
    }
}

// MARK: - Private Functions
private extension CoreDataStorageContext {
    
    func initDB(modelName: String? = nil, storeType: StoreType) {
        let coordinator = CoreDataStoreCoordinator.persistentStoreCoordinator(modelName: modelName, storeType: storeType)
        self.managedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedContext?.persistentStoreCoordinator = coordinator
    }
    
}
