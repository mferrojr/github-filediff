//
//  PRListTable.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/28/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

class PRListTable: NSObject {
    
    // MARK: - Variables

    // MARK: Public

    // MARK: Private
    private weak var owner: PRListViewController?
    private var viewModel: PRListViewModel
    private let dataSource = PRListDataSource()

    // MARK: - Initializations
    init(viewModel: PRListViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Functions
    
    // MARK: Public
    func setup(_ owner: PRListViewController) {
        self.owner = owner
        let tableView = owner.tableView

        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        tableView.register(PRTableViewCell.self, forCellReuseIdentifier: PRTableViewCell.ReuseId)
    }
    
    func refreshDataSource() {
        self.dataSource.refresh()
    }

}

//MARK: UITableViewDelegate
extension PRListTable: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.viewModel.cancelFetchData()
        
        self.owner?.pullRequestSelected(self.dataSource.datas[indexPath.row])
    }

}
