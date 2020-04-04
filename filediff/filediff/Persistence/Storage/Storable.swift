//
//  Storable.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

protocol Storable {
    func toMappable() -> Mappable
}

protocol HasStorable {
    var storable: Storable? { get set }
}
