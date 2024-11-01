//
//  GitHubFile.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubFile {
    
    // MARK: - Properties
    var name = ""
    var groups = [GitHubFileGroup]()
    var cellHeight : CGFloat?
    
    mutating func setName(value: String) {
        name = value
    }
    
    mutating func addGroup(value: GitHubFileGroup) {
        groups.append(value)
    }
    
    mutating func setCellHeight(value : CGFloat) {
        cellHeight = value
    }
}

struct GitHubFileGroup {
    
    // MARK: - Properties
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
    
    // MARK: - Properties
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
}
