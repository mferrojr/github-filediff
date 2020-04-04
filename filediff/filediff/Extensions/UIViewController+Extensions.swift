//
//  UIViewControllerExtensions.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

enum FileDiffSegue : String {
    case showPRDetails = "showPRDetails"
    case displayPRDiff = "displayPRDiff"
}

extension UIViewController {
    
    func performSegaue(_ segue : FileDiffSegue) {
        self.performSegue(withIdentifier: segue.rawValue, sender: self)
    }
    
    func displayError() {
        let alert = UIAlertController(title: "Error", message: "Unable to load data", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
