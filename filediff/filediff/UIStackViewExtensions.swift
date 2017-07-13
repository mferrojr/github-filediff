//
//  UIStackViewExtensions.swift
//  filediff
//
//  Created by bn-user on 7/13/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    
    func removeArrangedSubviews(){
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
}
