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
    fileprivate let TOP_PADDING : CGFloat = 10
    fileprivate let GROUP_COLOR = UIColor(red: 0.945, green: 0.973, blue: 1, alpha: 1)
    fileprivate let FONT_SIZE : CGFloat = 8
    fileprivate let LINE_NUMBER_WIDTH : CGFloat = 25
    fileprivate let FILE_NAME_SIZE : CGFloat = 17
    
    fileprivate var model : FileDiffTableViewModel!
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var nameLabel: UILabel!
    @IBOutlet weak fileprivate var beforeStackView: UIStackView!
    @IBOutlet weak fileprivate var afterStackView: UIStackView!
    
    //MARK: - Public Functions
    func configure(_ model : FileDiffTableViewModel) {
        self.model =  model
        
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
    
    func getCellHeight() -> CGFloat {
        var height = TOP_PADDING + (FILE_NAME_SIZE * 1.5)
        
        for group in model.groups {
            height = height + FONT_SIZE
            height = height + (CGFloat(group.afterDiffs.count) * (FONT_SIZE + 0.5))
        }
        
        return height
    }
    
    //MARK: - Private Functions
    fileprivate func addGroupRow(title: String){
        //Add Before
        if let textLabel = createLabel(text: title, color: GROUP_COLOR) {
            let textContainer = createGroupContainer(textLabel: textLabel)
            beforeStackView.addArrangedSubview(textContainer)
        }
        
        //Add After
        if let blankLabel = createLabel(text: " ", color: GROUP_COLOR) {
            let blankTextContainer = createGroupContainer(textLabel: blankLabel)
            afterStackView.addArrangedSubview(blankTextContainer)
        }
    }
    
    fileprivate func addBeforeRow(withDiff diff: GitHubFileDiff){
        let numberLabel = createLabel(text: getLineNumber(number: diff.lineNumber), color: diff.type.getLineNumberColor())
        numberLabel?.textAlignment = .center
        let textLabel = createLabel(text: diff.text, color: diff.type.getDiffColor())
        
        let container = createRowContainer(numberLabel: numberLabel, textLabel: textLabel)
        beforeStackView.addArrangedSubview(container)
    }
    
    fileprivate func addAfterRow(withDiff diff: GitHubFileDiff){
        let numberLabel = createLabel(text: getLineNumber(number: diff.lineNumber), color: diff.type.getLineNumberColor())
        numberLabel?.textAlignment = .center
        let textLabel = createLabel(text: diff.text, color: diff.type.getDiffColor())
        
        let container = createRowContainer(numberLabel: numberLabel, textLabel: textLabel)
        afterStackView.addArrangedSubview(container)
    }
    
    fileprivate func createGroupContainer(textLabel : UILabel) -> UIView {
        let container = UIView()
        container.addSubview(textLabel)
        
        textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: FONT_SIZE).isActive = true
        
        return container
    }
    
    fileprivate func createLabel(text: String?, color: UIColor) -> UILabel? {
        guard let text = text else {
            return nil
        }
        
        let textLabel = UILabel()
        textLabel.backgroundColor = color
        textLabel.text = text
        textLabel.font = textLabel.font.withSize(FONT_SIZE)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 1
        textLabel.sizeToFit()
        
        return textLabel
    }
    
    fileprivate func createRowContainer(numberLabel : UILabel?, textLabel: UILabel?) -> UIView {
        let view = UIView()
        view.backgroundColor = GitHubFileDiffType.blank.getDiffColor()
        
        if let numberLabel = numberLabel {
            view.addSubview(numberLabel)
            numberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            numberLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            numberLabel.widthAnchor.constraint(equalToConstant: LINE_NUMBER_WIDTH).isActive = true
            numberLabel.heightAnchor.constraint(equalToConstant: FONT_SIZE).isActive = true
        }
        
        if let textLabel = textLabel {
            view.addSubview(textLabel)
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LINE_NUMBER_WIDTH).isActive = true
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            textLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            textLabel.heightAnchor.constraint(equalToConstant: FONT_SIZE).isActive = true
        }
        
        return view
    }
    
    fileprivate func clearArrangedSubviews(){
        beforeStackView.removeSubviews()
        afterStackView.removeSubviews()
    }
    
    fileprivate func getLineNumber(number : Int?) -> String? {
        return number != nil ? String(number!) : nil
    }
    
}
