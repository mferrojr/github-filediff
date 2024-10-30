//
//  UIViewControllerExtensions.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
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
