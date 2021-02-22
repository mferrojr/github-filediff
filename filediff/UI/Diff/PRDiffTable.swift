//
//  PRDiffTable.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/29/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

final class PRDiffTable: NSObject {
    
    // MARK: - Properties
    
    // MARK: Private
    private weak var owner: PRDiffViewController?
    private var viewModel: PRDiffViewModel
    private let dataSource = PRDiffDataSource()

    // MARK: - Initializations
    init(viewModel: PRDiffViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Functions
    func setup(_ owner: PRDiffViewController) {
        self.owner = owner
        let tableView = owner.tableView

        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        tableView.register(FileDiffTableViewCell.self, forCellReuseIdentifier: FileDiffTableViewCell.ReuseId)
    }
    
    func refreshDataSource(with files: [GitHubFile]) {
        self.dataSource.refresh(files: files)
    }

}

//MARK: UITableViewDelegate
extension PRDiffTable: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.dataSource.getCellHeight(index: indexPath.row) ?? UITableView.automaticDimension
    }

}
