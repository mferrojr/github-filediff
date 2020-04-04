//
//  DomainBaseEntity.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import CoreData

protocol DomainBaseEntity: Mappable {
    var objectID: NSManagedObjectID? { get set }
}
