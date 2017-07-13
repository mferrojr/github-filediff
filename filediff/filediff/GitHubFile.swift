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
    var diffs:[Int: lineDiff] = [:]
    
    mutating func setTitle(value: String) {
        title = value
    }
    
    mutating func addDiff(key: Int, value: lineDiff) {
        diffs[key] = value
    }
}

struct GitHubFileDiff {
    var type : GitHubFileDiffType = .same
    var text = ""
    
    mutating func setType(value: GitHubFileDiffType) {
        type = value
    }
    
    mutating func setText(value: String) {
        text = value
    }
}

enum GitHubFileDiffType {
    case same, blank, remove, add
    
    func getColor() -> UIColor {
        switch self {
        case .same:
            return .clear
        case .blank:
            return UIColor(red: 0.980, green: 0.984, blue: 0.988, alpha: 1)
        case .remove:
            return UIColor(red: 0.937, green: 0.839, blue: 0.839, alpha: 1)
        case .add:
            return UIColor(red: 0.835, green: 0.914, blue: 0.808, alpha: 1)
        }
    }
    
    func getForegroundColor() -> UIColor {
        switch self {
        case .remove:
            return UIColor(red: 252/255, green: 184/255, blue: 193/255, alpha: 1)
        case .add:
            return UIColor(red: 174/255, green: 241/255, blue: 191/255, alpha: 1)
        default:
            return getColor()
        }
    }

    
}
