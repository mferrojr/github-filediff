//
//  DataStoreCoreData.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 3/30/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import CoreData

class DatastoreCoreData: Datastore {
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "filediff")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
