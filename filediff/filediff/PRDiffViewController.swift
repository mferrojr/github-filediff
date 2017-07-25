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
    fileprivate let queue = FileDiffQueue()
    
    //MARK: View Lifecycle
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
        queue.cancel()
    }
    
    //MARK: - Private Functions
    fileprivate func setUpTable(){
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        self.tableView.tableHeaderView = UIView(frame: .zero)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addSubview(refreshCtrl)
    }
    
    @objc
    fileprivate func reload(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    fileprivate func fetchData() {
        queue.getFileDiff(diffUrl: diffUrl,
        completion: { result in
            switch result {
            case .success(let value):
                if let value = value {
                    self.dataSource.refresh(files: value)
                }
                
                // UI Changes on the main queue
                DispatchQueue.main.async { [unowned self] in
                    self.stopLoading()
                    self.tableView.reloadData()
                }
            case .error:
                // UI Changes on the main queue
                DispatchQueue.main.async { [unowned self] in
                    self.stopLoading()
                    self.displayError()
                }
            }
        })
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

//MARK: - UITableViewDelegate
extension PRDiffViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.getCellHeight(index: indexPath.row) ?? UITableViewAutomaticDimension
    }
}
