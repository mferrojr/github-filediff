//
//  PRDiffViewController.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import UIKit

final class PRDiffViewController: UIViewController {

    //MARK: - Public Variables
    var diffUrl = ""
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get {
            return .landscapeLeft
        }
    }
    
    override var shouldAutorotate : Bool {
        get {
            return true
        }
    }
    
    //MARK: - Private Variables
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
    
    lazy var refreshCtrl: UIRefreshControl = { [weak self] in
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("PullToRefresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)
        return refreshControl
        }()
    
    fileprivate let dataSource = PRDiffDataSource()
    fileprivate var prDiffOperation : SyncPRDiffOperation?
    
    //MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        
        self.setUpTable()
        self.fetchData()
        self.refreshCtrl.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        prDiffOperation?.completionBlock = {
            self.prDiffOperation = nil
            self.dataSource.refresh()
            
            // UI Changes on the main queue
            DispatchQueue.main.async {
                self.stopLoading()
                self.tableView.reloadData()
            }
        }
        prDiffOperation?.errorCallback = { _, _ in
            // UI Changes on the main queue
            DispatchQueue.main.async {
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
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        tableView.isHidden = false
    }

}
