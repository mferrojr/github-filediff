//
//  Mappable.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import CoreData

protocol Mappable {
    var objectID: NSManagedObjectID? { get set }
    func populate(storable: Storable) -> Storable
}
