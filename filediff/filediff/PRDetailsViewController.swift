//
//  PRDetailsViewController.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class PRDetailsViewController : UIViewController {
    
    //MARK: - Public Varibales
    var prId = 0
    var prNumber = 0
    
    //MARK: - Private Variables
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var stackView: UIStackView!
    @IBOutlet weak fileprivate var descriptionLabel: UILabel!
    @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var prDetailOperation : SyncPRDetailsOperation?
    
    //MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "PR #\(prNumber)"
        
        self.fetchData()
        self.showLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func viewDiffPressed(_ sender: UIButton) {
        performSegaue(.displayPRDiff)
    }
    
    //MARK: - Private Functions
    fileprivate func fetchData() {
        let queue = OperationQueue()
        prDetailOperation = SyncPRDetailsOperation()
        prDetailOperation?.prNumber = prNumber
        prDetailOperation?.completionBlock = {
            // UI Changes on the main queue
            DispatchQueue.main.async {
                self.stopLoading()
                self.updateView()
            }
        }
        prDetailOperation?.errorCallback = { _, _ in
            DispatchQueue.main.async {
                self.stopLoading()
                self.displayError()
            }
        }
        
        if let op = prDetailOperation {
            queue.addOperation(op)
        }
    }
    
    fileprivate func updateView() {
        guard let realm = try? Realm() else { return }
        
        let repo = PRRepository(realm)
        guard let pr = repo.getById(id: prId) else { return }
    
        titleLabel.text = pr.title
        descriptionLabel.text = pr.body
    }
    
    fileprivate func showLoading(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    fileprivate func stopLoading(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        stackView.isHidden = false
    }
    
    fileprivate func setUpStackView() {
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
}
