//
//  PRTableViewCell.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import UIKit

struct PRTableViewCellModel {
    var title: String?
    var subTitle = ""
}

final class PRTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let ReuseId = String(describing: PRTableViewCell.self)
    
    // MARK: Private
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.subTitleLabel.text = nil
    }
    
    // MARK: - Functions
    func configure(_ model : PRTableViewCellModel) {
        self.titleLabel.text = model.title
        self.subTitleLabel.text = model.subTitle
    }

}

// MARK: - Private Functions
private extension PRTableViewCell {
    
    func setup() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.subTitleLabel)
        
        let padding: CGFloat = 8
        
        self.titleLabel.topAnchor.constraint(
            equalTo: self.contentView.topAnchor, constant: padding).isActive = true
        self.titleLabel.leadingAnchor.constraint(
            equalTo: self.contentView.leadingAnchor, constant: padding).isActive = true
        self.titleLabel.trailingAnchor.constraint(
            equalTo: self.contentView.trailingAnchor, constant: -padding).isActive = true
        
        self.subTitleLabel.topAnchor.constraint(
            equalTo: self.titleLabel.bottomAnchor, constant: 2).isActive = true
        self.subTitleLabel.leadingAnchor.constraint(
            equalTo: self.contentView.leadingAnchor, constant: padding).isActive = true
        self.subTitleLabel.trailingAnchor.constraint(
            equalTo: self.contentView.trailingAnchor, constant: -padding).isActive = true
        self.subTitleLabel.bottomAnchor.constraint(
            equalTo: self.contentView.bottomAnchor, constant: -padding).isActive = true
    }
    
}
