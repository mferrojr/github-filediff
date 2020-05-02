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
    
    // MARK: - Variables
    
    // MARK: Public
    static let ReuseId = String(describing: FileDiffTableViewCell.self)
    
    //MARK: Private
    private let TOP_PADDING : CGFloat = 10
    private let GROUP_COLOR = UIColor(red: 0.945, green: 0.973, blue: 1, alpha: 1)
    private let FONT_SIZE : CGFloat = 8
    private let LINE_NUMBER_WIDTH : CGFloat = 25
    private let FILE_NAME_SIZE : CGFloat = 17
    
    private var model: FileDiffTableViewModel!
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var containerDiffStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var beforeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var afterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let MARGIN: CGFloat = 0
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override
    func prepareForReuse() {
       self.nameLabel.text = nil
    }
    
    //MARK: - Functions
    
    //MARK: Public
    func configure(_ model : FileDiffTableViewModel) {
        self.model =  model
        
        self.clearArrangedSubviews()
        
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
    
    //MARK: Private
    private func setup() {
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.containerStackView)
        self.containerStackView.addSubview(self.nameLabel)
        self.containerStackView.addSubview(self.containerDiffStackView)
        
        self.setupContainerView()
        self.setupContainerScrollView()
        self.setUpNameLabel()
        self.setupDiffContainerScrollView()
        self.containerDiffStackView.addArrangedSubview(self.beforeStackView)
        self.containerDiffStackView.addArrangedSubview(self.afterStackView)
    }
    
    private func setupContainerView() {
        self.containerView.leadingAnchor.constraint(
            equalTo: self.contentView.leadingAnchor).isActive = true
        self.containerView.trailingAnchor.constraint(
            equalTo: self.contentView.trailingAnchor).isActive = true
        self.containerView.topAnchor.constraint(
            equalTo: self.contentView.topAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(
            equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    private func setupContainerScrollView() {
        self.containerStackView.leadingAnchor.constraint(
            equalTo: self.containerView.leadingAnchor).isActive = true
        self.containerStackView.trailingAnchor.constraint(
            equalTo: self.containerView.trailingAnchor).isActive = true
        self.containerStackView.topAnchor.constraint(
            equalTo: self.containerView.topAnchor).isActive = true
        self.containerStackView.bottomAnchor.constraint(
            equalTo: self.containerView.bottomAnchor).isActive = true
    }
    
    private func setUpNameLabel() {
        self.nameLabel.leadingAnchor.constraint(
            equalTo: containerStackView.leadingAnchor, constant: MARGIN).isActive = true
        self.nameLabel.trailingAnchor.constraint(
            equalTo: containerStackView.trailingAnchor, constant: -MARGIN).isActive = true
        self.nameLabel.topAnchor.constraint(
            equalTo: containerStackView.topAnchor, constant: MARGIN).isActive = true
        self.nameLabel.bottomAnchor.constraint(
            equalTo: containerDiffStackView.topAnchor, constant: -MARGIN).isActive = true
    }
    
    private func setupDiffContainerScrollView() {
        self.containerDiffStackView.leadingAnchor.constraint(
           equalTo: self.containerStackView.leadingAnchor).isActive = true
        self.containerDiffStackView.trailingAnchor.constraint(
           equalTo: self.containerStackView.trailingAnchor).isActive = true
        self.containerDiffStackView.topAnchor.constraint(
            equalTo: self.nameLabel.bottomAnchor).isActive = true
        self.containerDiffStackView.bottomAnchor.constraint(
           equalTo: self.containerStackView.bottomAnchor).isActive = true
    }
    
    private func addGroupRow(title: String){
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
    
    private func addBeforeRow(withDiff diff: GitHubFileDiff){
        let numberLabel = createLabel(text: getLineNumber(number: diff.lineNumber), color: diff.type.getLineNumberColor())
        numberLabel?.textAlignment = .center
        let textLabel = createLabel(text: diff.text, color: diff.type.getDiffColor())
        
        let container = createRowContainer(numberLabel: numberLabel, textLabel: textLabel)
        beforeStackView.addArrangedSubview(container)
    }
    
    private func addAfterRow(withDiff diff: GitHubFileDiff){
        let numberLabel = createLabel(text: getLineNumber(number: diff.lineNumber), color: diff.type.getLineNumberColor())
        numberLabel?.textAlignment = .center
        let textLabel = createLabel(text: diff.text, color: diff.type.getDiffColor())
        
        let container = createRowContainer(numberLabel: numberLabel, textLabel: textLabel)
        afterStackView.addArrangedSubview(container)
    }
    
    private func createGroupContainer(textLabel : UILabel) -> UIView {
        let container = UIView()
        container.addSubview(textLabel)
        
        textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: FONT_SIZE).isActive = true
        
        return container
    }
    
    private func createLabel(text: String?, color: UIColor) -> UILabel? {
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
    
    private func createRowContainer(numberLabel : UILabel?, textLabel: UILabel?) -> UIView {
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
    
    private func clearArrangedSubviews(){
        beforeStackView.removeSubviews()
        afterStackView.removeSubviews()
    }
    
    private func getLineNumber(number : Int?) -> String? {
        return number != nil ? String(number!) : nil
    }
    
}
