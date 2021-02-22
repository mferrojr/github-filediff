//
//  ConfigurationType.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

public enum ConfigurationType {
    case basic(identifier: String)
    case inMemory(identifier: String?)

    var identifier: String? {
        switch self {
        case .basic(let identifier): return identifier
        case .inMemory(let identifier): return identifier
        }
    }
}
