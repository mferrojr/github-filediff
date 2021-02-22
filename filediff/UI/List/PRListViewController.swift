//
//  PRListViewController.swift
//  filediff
//
//  Created by Michael Ferro on 7/9/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

final class PRListViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: MainCoordinator?
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: Private
    private let table: PRListTable
    private var viewModel: PRListViewModel
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }()
    
    lazy var refreshCtrl: UIRefreshControl = { [weak self] in
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: .localize(.pullToRefresh))
        refreshControl.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Initialization
    init() {
        self.viewModel = PRListViewModel()
        self.table = PRListTable(viewModel: viewModel, prService: Services.prEntityService)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        super.loadView()
        self.navigationItem.title = .localize(.pullRequests)
        self.viewModel.delegate = self
        self.table.setup(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.setUpActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchData()
    }

    // MARK: - Functions
    func pullRequestSelected(_ entity: GitHubPREntity) {
        self.coordinator?.viewPullRequestDetailsBy(entity: entity)
    }
}


// MARK: - Extensions

// MARK: PRListViewModelDelegate
extension PRListViewController: PRListViewModelDelegate {
    
    func requestPRsCompleted(with result: Result<Void, Error>) {
        switch result {
        case .success:
            self.table.refreshDataSource()
            self.stopLoading()
            self.tableView.reloadData()
        case .failure:
            self.stopLoading()
            self.displayError()
        }
    }
    
    func requestPRsCancelled() {
        self.stopLoading()
    }
    
}

// MARK: - Private Functions
private extension PRListViewController {
    
    func setUpTableView() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.tableView.tableHeaderView = UIView(frame: .zero)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addSubview(self.refreshCtrl)
    }
    
    func setUpActivityIndicator() {
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc
    func reload(_ refreshControl: UIRefreshControl) {
        self.viewModel.fetchData()
    }
    
    func stopLoading(){
        refreshCtrl.endRefreshing()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
