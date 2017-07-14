//
//  PRDiffDataSource.swift
//  filediff
//
//  Created by Michael Ferro on 7/12/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

class PRDiffDataSource : NSObject, UITableViewDataSource {
    
    private(set) var datas = [GitHubFile]()
    
    fileprivate let FILE_DELIMITER = "diff --git "
    fileprivate let GROUP_DELIMITER = "@@ "
    fileprivate let ROW_DELIMITER = "\n"
    
    //MARK: - Public Functions
    func refresh(fileText: String){
        // Clear
        datas.removeAll()

        // Clean up format
        let files = preProcess(input: fileText)
        
        // Start by breaking up by file
        for file in files {
            datas.append(processFile(file: file))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileDiffCell.fileDiffCell.rawValue, for: indexPath) as! FileDiffTableViewCell
        
        let model = datas[indexPath.row]
        
        cell.configure(FileDiffTableViewModel(name: model.name, groups: model.groups))
        
        return cell
    }
    
    //MARK: - Private Functions
    fileprivate func preProcess(input : String) -> [String] {
        let text = input.replacingOccurrences(of: "\t", with: "    ")
        return text.components(separatedBy: FILE_DELIMITER)
    }
    
    fileprivate func processFile(file : String) -> GitHubFile {
        var ghFile = GitHubFile()
        
        // Get File Title
        var lines = file.components(separatedBy: ROW_DELIMITER)
        if let index = lines[0].range(of: "/", options: .backwards)?.lowerBound {
            ghFile.setName(value: lines[0].substring(from: lines[0].index(index, offsetBy: 1)))
        }
        
        // Remove file info and break the file into groups
        guard let groupRange = file.range(of: GROUP_DELIMITER)?.lowerBound else { return ghFile }
        let groups = file.substring(from: groupRange)
        
        // For each group
        for group in groups.getMatches(pattern: "@@ .* @@") {
            ghFile.addGroup(value: processGroup(group: group))
        }
        
        return ghFile
    }
    
    fileprivate func processGroup(group : String) -> GitHubFileGroup {
        // Break up into each line
        var lines = group.components(separatedBy: ROW_DELIMITER)
        
        // New group
        var fileGroup = GitHubFileGroup()
        fileGroup.setTitle(value: lines[0])
        
        guard lines.count > 1 else { return fileGroup }
        
        // Parse "@@ -31,22 +31,17 @@" to extract line diffs
        var lineDiffs = lines[0].components(separatedBy: " ")
        var beforeDiffComma = lineDiffs[1].components(separatedBy: ",")
        var afterDiffComma = lineDiffs[2].components(separatedBy: ",")
        
        let bDiffFirst = beforeDiffComma[1]
        var beforeLineIndex = Int(bDiffFirst.substring(from: bDiffFirst.index(bDiffFirst.startIndex, offsetBy: 1))) ?? 0
        
        let aDiffFirst = afterDiffComma[1]
        var afterLineIndex = Int(aDiffFirst.substring(from: aDiffFirst.index(aDiffFirst.startIndex, offsetBy: 1))) ?? 0
        
        // Add lines to diff
        var removingLinesCount = 0
        var addingLinesCount = 0
        
        for line in lines[1..<lines.endIndex]{
            let type = processLine(line: line, fileGroup: &fileGroup, afterLineIndex: afterLineIndex,beforeLineIndex:beforeLineIndex, addingLinesCount: addingLinesCount, removingLinesCount: removingLinesCount )
            switch type {
            case .add:
                // Add line number
                afterLineIndex = afterLineIndex + 1
                // Update difference
                addingLinesCount = addingLinesCount + 1
                removingLinesCount = removingLinesCount - 1
            case .remove:
                // Add line number
                beforeLineIndex = beforeLineIndex + 1
                // Update difference
                removingLinesCount = removingLinesCount + 1
                addingLinesCount = addingLinesCount - 1
            default:
                addingLinesCount = 0
                removingLinesCount = 0
                
                // Increment
                beforeLineIndex = beforeLineIndex + 1
                afterLineIndex = afterLineIndex + 1
            }
        }
        
        // Fill in blanks
        let linesChanges = max((Int(beforeDiffComma[1]) ?? 0), (Int(afterDiffComma[1]) ?? 0))
        let beforeDiffsCount = linesChanges - fileGroup.beforeDiffs.count
        let afterDiffsCount = linesChanges - fileGroup.afterDiffs.count
        
        fillInBlanks(fileGroup: &fileGroup, addBeforeLines: beforeDiffsCount, addingAfterLines: afterDiffsCount)
        
        return fileGroup
    }
    
    fileprivate func processLine(line : String, fileGroup : inout GitHubFileGroup, afterLineIndex: Int, beforeLineIndex : Int, addingLinesCount: Int, removingLinesCount : Int) -> GitHubFileDiffType {
        // Adding line
        if line.hasPrefix("+"){
            var afterDiff = GitHubFileDiff()
            afterDiff.setText(value: line)
            afterDiff.setType(value: .add)
            afterDiff.setLineNumber(value: afterLineIndex)
            fileGroup.addAfterDiff(value: afterDiff)
            return .add
        }
        // Removing line
        else if line.hasPrefix("-"){
            var beforeDiff = GitHubFileDiff()
            beforeDiff.setText(value: line)
            beforeDiff.setType(value: .remove)
            beforeDiff.setLineNumber(value: beforeLineIndex)
            fileGroup.addBeforeDiff(value: beforeDiff)
            return .remove
        }
        // No change
        else {
            fillInBlanks(fileGroup: &fileGroup, addBeforeLines: addingLinesCount, addingAfterLines: removingLinesCount)
            
            // Same line so add to both
            var beforeDiff = GitHubFileDiff()
            beforeDiff.setText(value: line)
            beforeDiff.setLineNumber(value: beforeLineIndex)
            fileGroup.addBeforeDiff(value: beforeDiff)
            var afterDiff = GitHubFileDiff()
            afterDiff.setText(value: line)
            afterDiff.setLineNumber(value: afterLineIndex)
            fileGroup.addAfterDiff(value: afterDiff)
            return .same
        }
    }
    
    fileprivate func fillInBlanks(fileGroup : inout GitHubFileGroup, addBeforeLines: Int, addingAfterLines : Int){
        // Fill in before blank rows
        if addBeforeLines > 0 {
            for _ in 1...addBeforeLines {
                var diff = GitHubFileDiff()
                diff.setType(value: .blank)
                fileGroup.addBeforeDiff(value: diff)
            }
        }
        
        // Fill in after blank rows
        if addingAfterLines > 0 {
            for _ in 1...addingAfterLines {
                var diff = GitHubFileDiff()
                diff.setType(value: .blank)
                fileGroup.addAfterDiff(value: diff)
            }
        }
    }
    
    fileprivate func calcStartLine() -> Int {
        return 0
    }
}
