//
//  PRDiffViewController.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import UIKit

final class PRDiffViewController: UIViewController {

    //MARK: - Properties
    weak var coordinator: MainCoordinator?
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: Private
    private var entity: GitHubPREntity
    private let table: PRDiffTable
    private var viewModel: PRDiffViewModel
    
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
    init(entity: GitHubPREntity) {
        self.entity = entity
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
        self.viewModel.delegate = self
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
        AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchDataFor(entity: self.entity)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
        self.viewModel.cancelFetchData()
    }
    
    // MARK: - Functions

}

// MARK: - Extensions

// MARK: PRDiffViewModelDelegate
extension PRDiffViewController: PRDiffViewModelDelegate {
    
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
    
    func requestPRDiffCancelled() {
        self.stopLoading()
    }
    
}

// MARK: Private Functions
private extension PRDiffViewController {
    
    @objc
    func reload(_ refreshControl: UIRefreshControl) {
        self.viewModel.fetchDataFor(entity: self.entity)
    }
    
    func stopLoading(){
        refreshCtrl.endRefreshing()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func setUpTableView() {
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
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
}

