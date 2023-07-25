//
//  PRRowViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 7/19/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

struct PRRowViewModel {
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
