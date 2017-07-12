//
//  PRListDataSource.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class PRListDataSource : NSObject, UITableViewDataSource {
    
    private(set) var datas = [GitHubPR]()
    
    //MARK: - Public Functions
    func refresh(){
        guard let realm = try? Realm() else { return }
        
        let repo = PRRepository(realm)
        datas = repo.getAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileDiffCell.prCell.rawValue, for: indexPath) as! PRTableViewCell
        
        let model = datas[indexPath.row]
        cell.configure(PRTableViewModel(title: model.title))

        return cell
    }
    
    //MARK: - Private Functions
}
