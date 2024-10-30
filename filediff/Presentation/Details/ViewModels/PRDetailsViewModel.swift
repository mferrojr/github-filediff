//
//  PRDetailsViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct PRDetailsViewModel {
    let entity: GitHubPullRequest
    
    var title: String {
        return "PR #\(self.entity.number)"
    }
    var btnTitle: String {
        .localize(.viewDiff)
    }
}
