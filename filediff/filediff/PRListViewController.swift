//
//  PRListViewController.swift
//  filediff
//
//  Created by Michael Ferro on 7/9/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

final class PRListViewController : UIViewController {
    
    //MARK: - Private Variables
    fileprivate let dataSource = PRListDataSource()
    fileprivate var prOperation : SyncPRsOperation?
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var prTableView: UITableView!
    
    lazy var refreshCtrl: UIRefreshControl = { [weak self] in
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("PullToRefresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTable()
        self.fetchData()
        self.refreshCtrl.beginRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let seg = FileDiffSegue(rawValue: identifier) else {
            return
        }
        
        switch seg {
        case .showPRDetails:
            guard let destVC = segue.destination as? PRDetailsViewController else { return }
            guard let row = self.prTableView.indexPathForSelectedRow?.row else { return }
            
            let model = dataSource.datas[row]
            destVC.prId = model.id
            destVC.prNumber = model.number
            
        default:
            break
        }
    }
    
    //MARK: - Private Functions
    fileprivate func setUpTable(){
        self.prTableView.delegate = self
        self.prTableView.dataSource = dataSource
        self.prTableView.tableHeaderView = UIView(frame: .zero)
        self.prTableView.tableFooterView = UIView(frame: .zero)
        self.prTableView.addSubview(refreshCtrl)
    }
    
    @objc
    fileprivate func reload(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    fileprivate func fetchData() {
        let queue = OperationQueue()
        prOperation = SyncPRsOperation()
        prOperation?.completionBlock = {
            self.prOperation = nil
            self.dataSource.refresh()
            
            // UI Changes on the main queue
            DispatchQueue.main.async {
                self.stopLoading()
                self.prTableView.reloadData()
            }
        }
        prOperation?.errorCallback = { _, _ in
            // UI Changes on the main queue
            DispatchQueue.main.async {
                self.stopLoading()
                self.displayError()
            }
        }
        if let op = prOperation {
            queue.addOperation(op)
        }
    }
    
    fileprivate func stopLoading() {
        self.refreshCtrl.endRefreshing()
    }
}


//MARK: - Extensions

//MARK: UITableViewDelegate
extension PRListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        prOperation?.cancel()
        prOperation = nil
        performSegaue(.showPRDetails)
    }

}
