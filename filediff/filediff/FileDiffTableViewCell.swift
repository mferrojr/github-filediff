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
            
            for (key,diff) in Array(group.diffs).sorted(by: {$0.0 < $1.0}) {
                addBeforeRow(forRow: key, withDiff: diff.0)
                addAfterRow(forRow: key, withDiff: diff.0)
            }
        }
    }
    
    //MARK: - Private Functions
    fileprivate func addGroupRow(title: String){
        //Add Before
        let textLabel = createLabel(text: title, color: groupColor, width: beforeStackView.frame.width)
        beforeStackView.addArrangedSubview(textLabel)
        
        //Add After
        let afterView = UIView()
        afterView.backgroundColor = groupColor
        afterView.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        afterView.widthAnchor.constraint(equalToConstant: afterStackView.frame.size.width).isActive = true
        afterStackView.addArrangedSubview(afterView)
    }
    
    fileprivate func addBeforeRow(forRow: Int, withDiff diff: GitHubFileDiff){
        let textLabel = createLabel(text: diff.text, color: diff.type.getColor(), width: beforeStackView.frame.width)
        beforeStackView.addArrangedSubview(textLabel)
    }
    
    fileprivate func addAfterRow(forRow: Int, withDiff diff: GitHubFileDiff){
        let textLabel = createLabel(text: diff.text, color: diff.type.getColor(), width: beforeStackView.frame.width)
        afterStackView.addArrangedSubview(textLabel)
    }
    
    fileprivate func createLabel(text: String, color: UIColor, width: CGFloat) -> UILabel {
        let textLabel = UILabel()
        textLabel.backgroundColor = color
        textLabel.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        textLabel.text = text
        textLabel.font = textLabel.font.withSize(12)
        return textLabel
    }
    
}
