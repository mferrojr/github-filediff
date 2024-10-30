//
//  Storable.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

protocol Storable {
    func toMappable() -> Mappable
}

protocol HasStorable {
    var storable: Storable? { get set }
}
