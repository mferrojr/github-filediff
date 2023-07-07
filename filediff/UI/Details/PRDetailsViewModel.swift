//
//  PRDetailsViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 6/28/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

import Foundation

struct PRDetailsViewModel {
    let entity: GitHubPREntity
    
    var title: String {
        return "PR #\(self.entity.number)"
    }
    var btnTitle: String {
        .localize(.viewDiff)
    }
}
