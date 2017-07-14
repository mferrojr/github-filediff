//
//  PRDiffViewController.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import UIKit

// VC to show PR Diff
final class PRDiffViewController: UIViewController {

    //MARK: - Public Variables
    var diffUrl = ""
    
    //MARK: - Private Variables
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
    
    lazy var refreshCtrl: UIRefreshControl = { [weak self] in
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)
        return refreshControl
        }()
    
    fileprivate let dataSource = PRDiffDataSource()
    fileprivate var prDiffOperation : SyncPRDiffOperation?
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension //TODO: Manually calculate for better scrolling
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
        
        self.fetchData()
        self.showLoading()
        self.setUpTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
        prDiffOperation?.cancel()
        prDiffOperation = nil
    }
    
    //MARK: - Private Functions
    fileprivate func setUpTable(){
        self.tableView.dataSource = dataSource
        self.tableView.tableHeaderView = UIView(frame: .zero)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addSubview(refreshCtrl)
    }
    
    @objc
    fileprivate func reload(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    fileprivate func fetchData() {
        let queue = OperationQueue()
        prDiffOperation = SyncPRDiffOperation()
        prDiffOperation?.diffUrl = diffUrl
        prDiffOperation?.completionBlock = { [unowned self] in
            self.dataSource.refresh(fileText: self.prDiffOperation!.fileText)
            self.prDiffOperation = nil

            // UI Changes on the main queue
            DispatchQueue.main.async { [unowned self] in
                self.stopLoading()
                self.tableView.reloadData()
            }
        }
        prDiffOperation?.errorCallback = { _ in
            // UI Changes on the main queue
            DispatchQueue.main.async { [unowned self] in
                self.stopLoading()
                self.displayError()
            }
        }
        if let op = prDiffOperation {
            queue.addOperation(op)
        }
    }
    
    fileprivate func showLoading(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    fileprivate func stopLoading(){
        refreshCtrl.endRefreshing()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

}
