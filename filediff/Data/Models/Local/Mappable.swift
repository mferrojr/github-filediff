//
//  Mappable.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import CoreData

protocol Mappable {
    var objectID: NSManagedObjectID? { get set }
    func populate(storable: Storable) -> Storable
}
