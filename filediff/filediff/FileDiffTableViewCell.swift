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
    var groups = [GitHubFileGroup]()
}

final class FileDiffTableViewCell: UITableViewCell {
    
    //MARK: - Private Variables
    fileprivate let groupColor = UIColor(red: 0.945, green: 0.973, blue: 1, alpha: 1)
    fileprivate let rowHeight : CGFloat = 20
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var nameLabel: UILabel!
    @IBOutlet weak fileprivate var beforeStackView: UIStackView!
    @IBOutlet weak fileprivate var afterStackView: UIStackView!
    
    func configure(_ model : FileDiffTableViewModel) {
        self.nameLabel.text = model.name
        
        for group in model.groups {
            addGroupRow(title: group.title)
            
            for (_,diff) in Array(group.diffs).sorted(by: {$0.0 < $1.0}) {
                addBeforeRow(diff: diff.0)
                addAfterRow(diff: diff.1)
            }
        }
    }
    
    //MARK: - Private Functions
    fileprivate func addGroupRow(title: String){
        //Add Before
        let textLabel = UILabel()
        textLabel.backgroundColor = groupColor
        textLabel.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: beforeStackView.frame.width).isActive = true
        textLabel.text = title
        textLabel.font = textLabel.font.withSize(12)
        beforeStackView.addArrangedSubview(textLabel)
        
        //Add After
        let afterView = UIView()
        afterView.backgroundColor = groupColor
        afterView.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        afterView.widthAnchor.constraint(equalToConstant: afterStackView.frame.size.width).isActive = true
        afterStackView.addArrangedSubview(afterView)
    }
    
    fileprivate func addBeforeRow(diff: GitHubFileDiff){
        
    }
    
    fileprivate func addAfterRow(diff: GitHubFileDiff){
        
    }
    
}
