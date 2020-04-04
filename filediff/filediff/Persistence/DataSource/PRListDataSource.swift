//
//  PRListDataSource.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

class PRListDataSource : NSObject, UITableViewDataSource {
    
    private(set) var datas = [GitHubPREntity]()
    private let gitHubPREntityService = GitHubPREntityService()
    
    //MARK: - Public Functions
    func refresh(){
        datas = gitHubPREntityService.fetchAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileDiffCell.prCell.rawValue, for: indexPath) as! PRTableViewCell
        
        let model = datas[indexPath.row]
        var subTitle = "#\(model.number)"
        
        if let login = model.user?.login {
            subTitle.append(" by \(login)")
        }
        cell.configure(PRTableViewModel(title: model.title, subTitle: subTitle))

        return cell
    }
    
    //MARK: - Private Functions
}
