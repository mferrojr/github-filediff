//
//  PRDiffDataSource.swift
//  filediff
//
//  Created by Michael Ferro on 7/12/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

struct DiffInfo {
    var startingLine = 1
    var numLines = 0
}

class PRDiffDataSource : NSObject, UITableViewDataSource {
    
    private(set) var datas = [GitHubFile]()
    
    fileprivate let FILE_DELIMITER = "diff --git "
    fileprivate let GROUP_DELIMITER = "@@"
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
        for group in groups.getMatches(pattern: "\(GROUP_DELIMITER) .* \(GROUP_DELIMITER)") {
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
        
        let parsed = parseLines(input: lines[0])
        
        var beforeLineNumber = parsed.0.startingLine
        var afterLineNumber = parsed.1.startingLine
        
        // Add lines to diff
        var removingLinesCount = 0
        var addingLinesCount = 0
        
        for line in lines[1..<lines.endIndex]{
            let type = processLine(
                line: line, fileGroup: &fileGroup,
                afterLineNumber: afterLineNumber,beforeLineNumber:beforeLineNumber,
                addingLinesCount: addingLinesCount, removingLinesCount: removingLinesCount)
            switch type {
            case .add:
                // Add line number
                afterLineNumber = afterLineNumber + 1
                // Update difference
                addingLinesCount = addingLinesCount + 1
                removingLinesCount = removingLinesCount - 1
            case .remove:
                // Add line number
                beforeLineNumber = beforeLineNumber + 1
                // Update difference
                removingLinesCount = removingLinesCount + 1
                addingLinesCount = addingLinesCount - 1
            default:
                // Increment
                beforeLineNumber = beforeLineNumber + 1
                afterLineNumber = afterLineNumber + 1
                
                // Reset difference
                addingLinesCount = 0
                removingLinesCount = 0
            }
        }
        
        // Fill in blanks
        let linesChanges = max(parsed.0.numLines, parsed.1.numLines)
        let beforeDiffsCount = linesChanges - fileGroup.beforeDiffs.count
        let afterDiffsCount = linesChanges - fileGroup.afterDiffs.count
        
        fillInBlanks(fileGroup: &fileGroup, addBeforeLines: beforeDiffsCount, addingAfterLines: afterDiffsCount)
        
        return fileGroup
    }
    
     // Parse "@@ -31,22 +31,17 @@" to extract line diffs
    fileprivate func parseLines(input : String) -> (DiffInfo,DiffInfo){
        var lineDiffs = input.components(separatedBy: " ")
        var beforeDiffComma = lineDiffs[1].components(separatedBy: ",")
        var afterDiffComma = lineDiffs[2].components(separatedBy: ",")
        
        let bDiffFirst = beforeDiffComma[0]
        let beforeLineIndex = Int(bDiffFirst.substring(from: bDiffFirst.index(bDiffFirst.startIndex, offsetBy: 1))) ?? 1
        
        let aDiffFirst = afterDiffComma[0]
        let afterLineIndex = Int(aDiffFirst.substring(from: aDiffFirst.index(aDiffFirst.startIndex, offsetBy: 1))) ?? 1
        
        let beforeParse = DiffInfo(startingLine: beforeLineIndex, numLines: Int(beforeDiffComma[1]) ?? 0)
        let afterParse = DiffInfo(startingLine: afterLineIndex, numLines: Int(afterDiffComma[1]) ?? 0)
        
        return (beforeParse,afterParse)
    }
    
    fileprivate func processLine(line : String, fileGroup : inout GitHubFileGroup, afterLineNumber: Int, beforeLineNumber : Int, addingLinesCount: Int, removingLinesCount : Int) -> GitHubFileDiffType {
        
        
        // Adding line
        if line.hasPrefix("+"){
            var fileDiff = GitHubFileDiff()
            fileDiff.setText(value: line)
            fileDiff.setType(value: .add)
            fileDiff.setLineNumber(value: afterLineNumber)
            fileGroup.addAfterDiff(value: fileDiff)
            return .add
        }
        // Removing line
        else if line.hasPrefix("-"){
            var fileDiff = GitHubFileDiff()
            fileDiff.setText(value: line)
            fileDiff.setType(value: .remove)
            fileDiff.setLineNumber(value: beforeLineNumber)
            fileGroup.addBeforeDiff(value: fileDiff)
            return .remove
        }
        // No change
        else {
            fillInBlanks(fileGroup: &fileGroup, addBeforeLines: addingLinesCount, addingAfterLines: removingLinesCount)
            
            // Before line #
            var bFileDiff = GitHubFileDiff()
            bFileDiff.setText(value: line)
            bFileDiff.setLineNumber(value: beforeLineNumber)
            fileGroup.addBeforeDiff(value: bFileDiff)
            
            // After line #
            var aFileDiff = GitHubFileDiff()
            aFileDiff.setText(value: line)
            aFileDiff.setLineNumber(value: afterLineNumber)
            fileGroup.addAfterDiff(value: aFileDiff)
            
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

}
