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
    var title = ""
    
    var beforeDiffs = [GitHubFileDiff]()
    var afterDiffs = [GitHubFileDiff]()
    
    mutating func setTitle(value: String) {
        title = value
    }
    
    mutating func addBeforeDiff(value: GitHubFileDiff) {
        beforeDiffs.append(value)
    }
    
    mutating func addAfterDiff(value: GitHubFileDiff) {
        afterDiffs.append(value)
    }
}

struct GitHubFileDiff {
    var type : GitHubFileDiffType = .same
    var text : String?
    var lineNumber : Int?
    
    mutating func setType(value: GitHubFileDiffType) {
        type = value
    }
    
    mutating func setText(value: String) {
        text = value
    }
    
    mutating func setLineNumber(value: Int?) {
        lineNumber = value
    }
}

enum GitHubFileDiffType {
    case same, blank, remove, add
    
    func getDiffColor() -> UIColor {
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
    
    func getLineNumberColor() -> UIColor {
        switch self {
        case .same:
            return .white
        case .blank:
            return getDiffColor()
        case .remove:
            return UIColor(red: 1, green: 0.863, blue: 0.878, alpha: 1)
        case .add:
            return UIColor(red: 0.804, green: 1, blue: 0.847, alpha: 1)
        }
    }
    
}
