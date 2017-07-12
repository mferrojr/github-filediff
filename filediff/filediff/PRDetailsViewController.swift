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
    @IBOutlet weak fileprivate var descriptionLabel: UILabel!
    
    fileprivate var prDetailOperation : SyncPRDetailsOperation?
    
    //MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "PR #\(prNumber)"
        
        self.fetchData()
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
                self.updateView()
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
    
}
