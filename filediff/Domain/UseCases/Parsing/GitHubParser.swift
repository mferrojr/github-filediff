//
//  GitHubParser.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

private struct DiffInfo {
    var startingLine = 1
    var numLines = 0
}

struct GitHubParser {
    
    //MARK: - Variables
    private static let FILE_DELIMITER = "diff --git "
    private static let GROUP_DELIMITER = "@@"
    private static let ROW_DELIMITER = "\n"
    
    static func parse(fileText : String) -> [GitHubFile]{
        var datas = [GitHubFile]()
        
        // Clean up format
        let files = preProcess(input: fileText)
        
        // Start by breaking up by file
        for file in files {
            datas.append(processFile(file: file))
        }
        
        return datas
    }

}

// MARK: - Private Functions
private extension GitHubParser {
    
    static func preProcess(input : String) -> [String] {
        let text = input.replacingOccurrences(of: "\t", with: "    ")
        return text.components(separatedBy: FILE_DELIMITER)
    }
    
    static func processFile(file : String) -> GitHubFile {
        var ghFile = GitHubFile()
        
        // Get File Title
        let lines = file.components(separatedBy: ROW_DELIMITER)
        if let index = lines[0].range(of: "/", options: .backwards)?.lowerBound {
            ghFile.setName(value: String(lines[0][lines[0].index(index, offsetBy: 1)...]))
        }
        
        // Remove file info and break the file into groups
        guard let groupRange = file.range(of: GROUP_DELIMITER)?.lowerBound else { return ghFile }
        let groups = String(file[groupRange...])
        
        // For each group
        for group in groups.getMatches(pattern: "\(GROUP_DELIMITER) .* \(GROUP_DELIMITER)") {
            ghFile.addGroup(value: processGroup(group: group))
        }
        
        return ghFile
    }
    
    static func processGroup(group : String) -> GitHubFileGroup {
        // Break up into each line
        let lines = group.components(separatedBy: ROW_DELIMITER)
        
        // New group
        var fileGroup = GitHubFileGroup()
        let groupComponents = group.components(separatedBy: GROUP_DELIMITER)
        
        guard groupComponents.count > 1 else { return fileGroup }
        
        fileGroup.setTitle(value: GROUP_DELIMITER + groupComponents[1] + GROUP_DELIMITER)
        
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
            case .some(.add):
                // Add line number
                afterLineNumber = afterLineNumber + 1
                // Update difference
                addingLinesCount = addingLinesCount + 1
                removingLinesCount = removingLinesCount - 1
            case .some(.remove):
                // Add line number
                beforeLineNumber = beforeLineNumber + 1
                // Update difference
                removingLinesCount = removingLinesCount + 1
                addingLinesCount = addingLinesCount - 1
            case .some(.blank), .some(.same):
                // Increment
                beforeLineNumber = beforeLineNumber + 1
                afterLineNumber = afterLineNumber + 1
                
                // Reset difference
                addingLinesCount = 0
                removingLinesCount = 0
            default:
                break
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
    static func parseLines(input : String) -> (DiffInfo,DiffInfo){
        let lineDiffs = input.components(separatedBy: " ")
        let beforeDiffComma = lineDiffs[1].components(separatedBy: ",")
        let afterDiffComma = lineDiffs[2].components(separatedBy: ",")
        
        let bDiffFirst = beforeDiffComma[0]
        let beforeLineIndex = Int(String(bDiffFirst[bDiffFirst.index(bDiffFirst.startIndex, offsetBy: 1)...])) ?? 1
        
        let aDiffFirst = afterDiffComma[0]
        let afterLineIndex = Int(String(aDiffFirst[aDiffFirst.index(aDiffFirst.startIndex, offsetBy: 1)...])) ?? 1
        
        let beforeParse = DiffInfo(startingLine: beforeLineIndex, numLines: Int(beforeDiffComma[1]) ?? 0)
        let afterParse = DiffInfo(startingLine: afterLineIndex, numLines: Int(afterDiffComma[1]) ?? 0)
        
        return (beforeParse,afterParse)
    }
    
    static func processLine(line : String, fileGroup : inout GitHubFileGroup, afterLineNumber: Int, beforeLineNumber : Int, addingLinesCount: Int, removingLinesCount : Int) -> GitHubFileDiffType? {
        guard !line.isEmpty else { return nil }
        
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
        else  {
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
    
    static func fillInBlanks(fileGroup : inout GitHubFileGroup, addBeforeLines: Int, addingAfterLines : Int){
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
