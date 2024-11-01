//
//  UIStackViewExtensions.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    
    func removeSubviews(){
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
}
