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
    fileprivate let groupFontSize : CGFloat = 12
    fileprivate let lineFontSize : CGFloat = 8
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var nameLabel: UILabel!
    @IBOutlet weak fileprivate var beforeStackView: UIStackView!
    @IBOutlet weak fileprivate var afterStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearArrangedSubviews()
    }
    
    //MARK: - Public Functions
    func configure(_ model : FileDiffTableViewModel) {
        clearArrangedSubviews()
        
        self.nameLabel.text = model.name
        
        for group in model.groups {
            addGroupRow(title: group.title)
            
            for diff in group.beforeDiffs {
                addBeforeRow(withDiff: diff)
            }
            
            for diff in group.afterDiffs {
                addAfterRow(withDiff: diff)
            }
        }
    }
    
    //MARK: - Private Functions
    fileprivate func addGroupRow(title: String){
        //Add Before
        let textLabel = createLabel(text: title, color: groupColor, size: groupFontSize)
        beforeStackView.addArrangedSubview(textLabel)
        
        //Add After
        let blankLabel = createLabel(text: " ", color: groupColor, size: groupFontSize)
        afterStackView.addArrangedSubview(blankLabel)
    }
    
    fileprivate func addBeforeRow(withDiff diff: GitHubFileDiff){
        let textLabel = createLabel(text: diff.text, color: diff.type.getColor(), size: lineFontSize)
        beforeStackView.addArrangedSubview(textLabel)
    }
    
    fileprivate func addAfterRow(withDiff diff: GitHubFileDiff){
        let textLabel = createLabel(text: diff.text, color: diff.type.getColor(), size: lineFontSize)
        afterStackView.addArrangedSubview(textLabel)
    }
    
    fileprivate func createLabel(text: String?, color: UIColor, size: CGFloat) -> UIView {
        let textLabel = UILabel()
        textLabel.backgroundColor = color
        textLabel.text = text ?? " "
        textLabel.font = textLabel.font.withSize(size)
        textLabel.numberOfLines = 0
        textLabel.sizeToFit()
        return textLabel
    }
    
    fileprivate func clearArrangedSubviews(){
        beforeStackView.removeArrangedSubviews()
        afterStackView.removeArrangedSubviews()
    }
    
}
