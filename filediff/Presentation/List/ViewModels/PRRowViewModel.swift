//
//  PRRowViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

struct PRRowViewModel {
    let title: String?
    let subTitle: String
    
    // MARK: - Initialization
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
