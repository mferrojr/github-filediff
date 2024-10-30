//
//  DataStoreCoreData.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import CoreData

final class DatastoreCoreData: Datastore {
    
    // MARK: - Properties
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "filediff")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Functions
    func save() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    
}
