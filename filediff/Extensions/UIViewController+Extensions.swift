//
//  UIViewControllerExtensions.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayError() {
        let alert = UIAlertController(title: "Error", message: "Unable to load data", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
