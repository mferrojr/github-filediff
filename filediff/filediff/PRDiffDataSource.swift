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
    func refresh(){
        /*guard let realm = try? Realm() else { return }
        
        let repo = PRRepository(realm)
        datas = repo.getAll()*/
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
