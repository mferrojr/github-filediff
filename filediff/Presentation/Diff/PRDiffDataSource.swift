//
//  PRDiffDataSource.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

final class PRDiffDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    private(set) var datas = [GitHubFile]()
    
    //MARK: - Functions
    func refresh(files: [GitHubFile]){
        self.datas = files
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileDiffTableViewCell.ReuseId, for: indexPath) as! FileDiffTableViewCell
        
        let model = datas[indexPath.row]
        
        cell.configure(FileDiffTableViewModel(name: model.name, groups: model.groups))
        setCellHeight(index: indexPath.row, height: cell.getCellHeight())
        
        return cell
    }
    
    func setCellHeight(index : Int, height : CGFloat){
        guard index < datas.count else { return }
        
        datas[index].setCellHeight(value: height)
    }
    
    func getCellHeight(index : Int) -> CGFloat? {
        guard index < datas.count else { return nil }
        
        return datas[index].cellHeight
    }
    
}
