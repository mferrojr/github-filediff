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
    init(entity: GitHubPullRequest) {
        var subTitle = "#\(entity.number)"
        if let login = entity.user?.login {
            subTitle.append(" opened by \(login)")
        }
        self.title = entity.title
        self.subTitle = subTitle
    }
}
