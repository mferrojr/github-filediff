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
    
    fileprivate let lineNumberWidth : CGFloat = 25
    
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
        
        // Add views for each file group
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
        let numberLabel = createLabel(text: getLineNumber(number: diff.lineNumber), color: diff.type.getLineNumberColor(), size: lineFontSize)
        numberLabel.textAlignment = .center
        let textLabel = createLabel(text: diff.text, color: diff.type.getDiffColor(), size: lineFontSize)
        
        let container = createContainer(numberLabel: numberLabel, textLabel: textLabel)
        beforeStackView.addArrangedSubview(container)
    }
    
    fileprivate func addAfterRow(withDiff diff: GitHubFileDiff){
        let numberLabel = createLabel(text: getLineNumber(number: diff.lineNumber), color: diff.type.getLineNumberColor(), size: lineFontSize)
        numberLabel.textAlignment = .center
        let textLabel = createLabel(text: diff.text, color: diff.type.getDiffColor(), size: lineFontSize)
        
        let container = createContainer(numberLabel: numberLabel, textLabel: textLabel)
        afterStackView.addArrangedSubview(container)
    }
    
    fileprivate func createLabel(text: String?, color: UIColor, size: CGFloat) -> UILabel {
        let textLabel = UILabel()
        textLabel.backgroundColor = color
        textLabel.text = text ?? " "
        textLabel.font = textLabel.font.withSize(size)
        textLabel.numberOfLines = 0
        
        return textLabel
    }
    
    fileprivate func createContainer(numberLabel : UILabel, textLabel: UILabel) -> UIView {
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(numberLabel)
        view.addSubview(textLabel)
        
        numberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        numberLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        numberLabel.widthAnchor.constraint(equalToConstant: lineNumberWidth).isActive = true
        
        textLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        return view
    }
    
    fileprivate func clearArrangedSubviews(){
        beforeStackView.removeArrangedSubviews()
        afterStackView.removeArrangedSubviews()
    }
    
    fileprivate func getLineNumber(number : Int?) -> String? {
        return number != nil ? String(number!) : nil
    }
    
}
