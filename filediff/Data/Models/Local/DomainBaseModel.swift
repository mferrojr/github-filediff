//
//  DomainBaseEntity.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import CoreData

protocol DomainBaseModel: Mappable {
    var objectID: NSManagedObjectID? { get set }
}
