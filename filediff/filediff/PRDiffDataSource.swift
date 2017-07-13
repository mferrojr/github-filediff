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
        let text = fileText.replacingOccurrences(of: "\t", with: "    ")
        let files = text.components(separatedBy: FILE_DELIMITER)
        
        // Start by breaking up by file
        for file in files {
            var ghFile = GitHubFile()
            
            // Get File Title
            var lines = file.components(separatedBy: ROW_DELIMITER)
            if let index = lines[0].range(of: "/", options: .backwards)?.lowerBound {
                ghFile.setName(value: lines[0].substring(from: lines[0].index(index, offsetBy: 1)))
            }
            
            // Remove file info and break the file into groups
            guard let groupRange = file.range(of: GROUP_DELIMITER)?.lowerBound else { continue }
            let groupsString = file.substring(from: groupRange)
            
            // For each group
            for groups in groupsString.getMatches(pattern: "@@ .* @@") {
                // Break up into each line
                var lines = groups.components(separatedBy: ROW_DELIMITER)
                
                // New group
                var fileGroup = GitHubFileGroup()
                fileGroup.setTitle(value: lines[0])
                
                guard lines.count > 1 else { continue }
                
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
                    // Adding line
                    if line.hasPrefix("+"){
                        var afterDiff = GitHubFileDiff()
                        afterDiff.setText(value: line)
                        afterDiff.setType(value: .add)
                        afterDiff.setLineNumber(value: afterLineIndex)
                        fileGroup.addAfterDiff(value: afterDiff)
                        
                        // Add line number
                        afterLineIndex = afterLineIndex + 1
                        // Keep track of difference
                        addingLinesCount = addingLinesCount + 1
                        removingLinesCount = removingLinesCount - 1
                    }
                    // Removing line
                    else if line.hasPrefix("-"){
                        var beforeDiff = GitHubFileDiff()
                        beforeDiff.setText(value: line)
                        beforeDiff.setType(value: .remove)
                        beforeDiff.setLineNumber(value: beforeLineIndex)
                        fileGroup.addBeforeDiff(value: beforeDiff)

                        // Add line number
                        beforeLineIndex = beforeLineIndex + 1
                        // Keep track of difference
                        removingLinesCount = removingLinesCount + 1
                        addingLinesCount = addingLinesCount - 1
                    }
                    // No change
                    else {
                        // Fill in before blank rows
                        if addingLinesCount > 0 {
                            for _ in 1...addingLinesCount {
                                var diff = GitHubFileDiff()
                                diff.setType(value: .blank)
                                fileGroup.addBeforeDiff(value: diff)
                            }
                            addingLinesCount = 0
                        }
                        
                        // Fill in after blank rows
                        if removingLinesCount > 0 {
                            for _ in 1...removingLinesCount {
                                var diff = GitHubFileDiff()
                                diff.setType(value: .blank)
                                fileGroup.addAfterDiff(value: diff)
                            }
                             removingLinesCount = 0
                        }
                        
                        // Same line so add to both
                        var beforeDiff = GitHubFileDiff()
                        beforeDiff.setText(value: line)
                        beforeDiff.setLineNumber(value: beforeLineIndex)
                        fileGroup.addBeforeDiff(value: beforeDiff)
                        var afterDiff = GitHubFileDiff()
                        afterDiff.setText(value: line)
                        afterDiff.setLineNumber(value: afterLineIndex)
                        fileGroup.addAfterDiff(value: afterDiff)
                        
                        // Increment
                        beforeLineIndex = beforeLineIndex + 1
                        afterLineIndex = afterLineIndex + 1
                    }
                }
                
                // Fill in blanks
                let linesChanges = max((Int(beforeDiffComma[1]) ?? 0), (Int(afterDiffComma[1]) ?? 0))
                let beforeDiffsCount = linesChanges - fileGroup.beforeDiffs.count
                let afterDiffsCount = linesChanges - fileGroup.afterDiffs.count
                
                if beforeDiffsCount > 0  {
                    for _ in 1...beforeDiffsCount {
                        var diff = GitHubFileDiff()
                        diff.setType(value: .blank)
                        fileGroup.addBeforeDiff(value: diff)
                    }
                }
                
                if afterDiffsCount > 0 {
                    for _ in 1...afterDiffsCount {
                        var diff = GitHubFileDiff()
                        diff.setType(value: .blank)
                        fileGroup.addAfterDiff(value: diff)
                    }
                }

                
                ghFile.addGroup(value: fileGroup)
            }
            
            datas.append(ghFile)
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
}
