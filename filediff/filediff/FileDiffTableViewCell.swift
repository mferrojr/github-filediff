//
//  FileDiffTableViewCell.swift
//  filediff
//
//  Created by Michael Ferro on 7/12/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

struct FileDiffTableViewModel {
    var name = ""
}

final class FileDiffTableViewCell: UITableViewCell {
    
    //MARK: - Private Variables
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var nameLabel: UILabel!
    @IBOutlet weak fileprivate var beforeStackView: UIStackView!
    @IBOutlet weak fileprivate var afterStackView: UIStackView!
    
    func configure(_ model : FileDiffTableViewModel) {
        self.nameLabel.text = model.name
    }
    
}
