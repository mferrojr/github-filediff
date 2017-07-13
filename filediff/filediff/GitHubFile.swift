//
//  GitHubFile.swift
//  filediff
//
//  Created by Michael Ferro on 7/12/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

struct GitHubFile {
    var name = ""
    var groups = [GitHubFileGroup]()
    
    mutating func setName(value: String) {
        name = value
    }
    
    mutating func addGroup(value: GitHubFileGroup) {
        groups.append(value)
    }
}

struct GitHubFileGroup {
    typealias lineDiff = (GitHubFileDiff,GitHubFileDiff)
    
    var title = ""
    var diffs = [Int: lineDiff]()
    
    mutating func setTitle(value: String) {
        title = value
    }
    
    mutating func addDiff(key: Int, value: lineDiff) {
        diffs[key] = value
    }
}

struct GitHubFileDiff {
    var type : GitHubFileDiffType = .none
    var text = ""
}

enum GitHubFileDiffType {
    case none, remove, add
    
    func getColor() -> UIColor {
        switch self {
        case .none:
            return .clear
        case .remove:
            return UIColor(red: 0.937, green: 0.839, blue: 0.839, alpha: 1)
        case .add:
            return UIColor(red: 0.835, green: 0.914, blue: 0.808, alpha: 1)
        }
    }
    
    func getSymbol() -> String {
        switch self {
        case .none:
            return ""
        case .remove:
            return "-"
        case .add:
            return "+"
        }
    }
    
}
