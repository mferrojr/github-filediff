//
//  DomainBaseEntity.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import CoreData

protocol DomainBaseEntity: Mappable {
    var objectID: NSManagedObjectID? { get set }
}
