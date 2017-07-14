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

// VC to show PR Details
final class PRDetailsViewController : UIViewController {
    
    //MARK: - Public Varibales
    var prId = 0
    var prNumber = 0
    
    //MARK: - Private Variables
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var stackView: UIStackView!
    @IBOutlet weak fileprivate var descriptionLabel: UILabel!
    @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var prDetailOperation : SyncPRDetailsOperation?
    fileprivate var diffUrl : String?
    fileprivate let MARGIN : CGFloat = 20
    
    //MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "PR #\(prNumber)"
        
        self.fetchData()
        self.showLoading()
        self.setUpStackView()
    }

    //MARK: - Actions
    @IBAction func viewDiffPressed(_ sender: UIButton) {
        performSegaue(.displayPRDiff)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let seg = FileDiffSegue(rawValue: identifier) else {
            return
        }
        
        switch seg {
        case .displayPRDiff:
            guard let destVC = segue.destination as? PRDiffViewController else { return }
            guard let diffUrl = diffUrl else { return }

            destVC.diffUrl = diffUrl
        default:
            break
        }
    }
    
    //MARK: - Private Functions
    fileprivate func fetchData() {
        let queue = OperationQueue()
        prDetailOperation = SyncPRDetailsOperation()
        prDetailOperation?.prNumber = prNumber
        prDetailOperation?.completionBlock = {
            // UI Changes on the main queue
            DispatchQueue.main.async { [unowned self] in
                self.stopLoading()
                self.updateView()
            }
        }
        prDetailOperation?.errorCallback = { _ in
            DispatchQueue.main.async { [unowned self] in
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
        
        // Store diffUrl if the user wants to see the diff
        diffUrl = pr.diff_url
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
        stackView.layoutMargins = UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
}
