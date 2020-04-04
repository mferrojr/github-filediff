//
//  PRDetailsViewController.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

// VC to show PR Details
final class PRDetailsViewController : UIViewController {
    
    //MARK: - Public Varibales
    var prId = 0
    var prNumber = 0
    
    //MARK: - Private Variables
    
    //MARK: IBOutlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var prDetailOperation : SyncPRDetailsOperation?
    private var diffUrl : String?
    private let MARGIN : CGFloat = 20
    private let gitHubPREntityService = GitHubPREntityService()
    
    //MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "PR #\(prNumber)"
        self.setUpStackView()
        self.fetchData()
        self.showLoading()
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
    private func fetchData() {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        
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
    
    private func updateView() {
        guard let pr = gitHubPREntityService.fetchBy(prNumber: prId) else { return }
    
        titleLabel.text = pr.title
        descriptionLabel.text = pr.body
        
        // Store diffUrl if the user wants to see the diff
        diffUrl = pr.diff_url
    }
    
    private func showLoading(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    private func stopLoading(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        stackView.isHidden = false
    }
    
    private func setUpStackView() {
        stackView.layoutMargins = UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
}
