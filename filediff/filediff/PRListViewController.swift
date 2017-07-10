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
    
    //MARK: Private Variables
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var prTableView: UITableView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: - Private Functions
}
