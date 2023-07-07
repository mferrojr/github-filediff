//
//  PRTableViewCell.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import UIKit
import SwiftUI

struct PRTableViewCellModel {
    let title: String?
    let subTitle: String
    
    init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
    }
    
    init(entity: GitHubPREntity) {
        var subTitle = "#\(entity.number)"
        if let login = entity.user?.login {
            subTitle.append(" by \(login)")
        }
        self.title = entity.title
        self.subTitle = subTitle
    }
}

final class PRTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let ReuseId = String(describing: PRTableViewCell.self)
    
    init(model : PRTableViewCellModel) {
        super.init(style: .default, reuseIdentifier: Self.ReuseId)
        let vc = UIHostingController(rootView: PRRowView(model: model))
        self.contentView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            vc.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        accessoryType = .disclosureIndicator
        selectionStyle = .default
    }
    
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
}
