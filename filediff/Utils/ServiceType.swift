//
//  ServiceType.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

/// [Reference](https://www.cobeisfresh.com/blog/dependency-injection-in-swift-using-property-wrappers)
enum ServiceType {
    case singleton
    case newSingleton
    case new
    case automatic
}
