//
//  PRDiffViewController.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import UIKit

final class PRDiffViewController: UIViewController {

    //MARK: - Properties
    weak var coordinator: MainCoordinator?
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    //MARK: Private
    private let diffUrl: String
    private let table: PRDiffTable
    private let viewModel: PRDiffViewModel
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    lazy var refreshCtrl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        return refreshControl
    }()
    
    // MARK: - Initialization
    init(diffUrl: String) {
        self.diffUrl = diffUrl
        self.viewModel = PRDiffViewModel()
        self.table = PRDiffTable(viewModel: self.viewModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        super.loadView()
        self.refreshCtrl.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)
        self.table.setup(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.setUpActivityIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Task {
            await self.viewModel.cancelFetchData()
            self.stopLoading()
        }
    }
}

// MARK: Private Functions
private extension PRDiffViewController {
    
    func fetchData() {
        Task {
            let result = await self.viewModel.fetchDataFor(diffUrl: diffUrl)
            self.requestPRDiffCompleted(with: result)
        }
    }
    
    func requestPRDiffCompleted(with result: Result<[GitHubFile], Error>) {
        switch result {
        case .success(let files):
            self.table.refreshDataSource(with: files)
            self.stopLoading()
            self.tableView.reloadData()
        case .failure:
            self.stopLoading()
            self.displayError()
        }
    }
    
    @objc
    func reload(_ refreshControl: UIRefreshControl) {
        self.fetchData()
    }

    func stopLoading(){
        refreshCtrl.endRefreshing()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func setUpTableView() {
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.tableView.tableHeaderView = UIView(frame: .zero)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addSubview(self.refreshCtrl)
    }
    
    func setUpActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
        NSLayoutConstraint.activate([
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
}
