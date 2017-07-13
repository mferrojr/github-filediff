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
    
    private(set) var files = [GitHubFile]()
    
    //MARK: - Public Functions
    func refresh(fileText: String){
        // Clear
        files.removeAll()

        // Clean up format
        let text = fileText.replacingOccurrences(of: "\t", with: "    ")
        let lines = text.components(separatedBy: "\n")
        
        var file: GitHubFile?
        for line in lines {
            // new file
            if line.contains("diff") {
                // add existing file to array if there is one
                if let file = file {
                    files.append(file)
                }
                file = GitHubFile()
                
                // Set the file name
                if let index = line.range(of: "/", options: .backwards)?.lowerBound {
                    file?.name = line.substring(from: line.index(index, offsetBy: 1))
                }
            }
            else {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileDiffCell.fileDiffCell.rawValue, for: indexPath) as! FileDiffTableViewCell
        
        let model = files[indexPath.row]
        
        cell.configure(FileDiffTableViewModel(name: model.name))
        
        return cell
    }
    
    //MARK: - Private Functions
}
