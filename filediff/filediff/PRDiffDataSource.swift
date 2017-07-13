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
    
    //MARK: - Public Functions
    func refresh(fileText: String){
        // Clear
        datas.removeAll()

        // Clean up format
        let text = fileText.replacingOccurrences(of: "\t", with: "    ")
        let files = text.components(separatedBy: "diff --git ")
        
        
        for file in files.filter({ !$0.isEmpty }) {
            var ghFile = GitHubFile()
            var isFirstLine = true

            for line in file.components(separatedBy: "\n") {
                if isFirstLine {
                    if let index = line.range(of: "/", options: .backwards)?.lowerBound {
                        ghFile.setName(value: line.substring(from: line.index(index, offsetBy: 1)))
                    }
                    
                    isFirstLine = false
                }
                // New Group
                else if line.hasPrefix("@@") && line.hasSuffix("@@"){
                    var group = GitHubFileGroup()
                    group.setTitle(value: line)
                    ghFile.addGroup(value: group)
                }
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
