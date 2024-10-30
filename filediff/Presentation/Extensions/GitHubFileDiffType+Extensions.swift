//
//  GitHubFileDiffType+Extensions.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

extension GitHubFileDiffType {
    
    var diffColor: UIColor {
        switch self {
        case .same:
            return .white
        case .blank:
            return UIColor(red: 0.980, green: 0.984, blue: 0.988, alpha: 1)
        case .remove:
            return UIColor(red: 1, green: 0.933, blue: 0.941, alpha: 1)
        case .add:
            return UIColor(red: 0.902, green: 1, blue: 0.929, alpha: 1)
        }
    }
    
    var lineNumberColor: UIColor {
        switch self {
        case .same:
            return .white
        case .blank:
            return self.diffColor
        case .remove:
            return UIColor(red: 1, green: 0.863, blue: 0.878, alpha: 1)
        case .add:
            return UIColor(red: 0.804, green: 1, blue: 0.847, alpha: 1)
        }
    }
}
