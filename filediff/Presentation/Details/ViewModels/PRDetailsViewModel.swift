//
//  PRDetailsViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import SwiftUI

final class PRDetailsViewModel: ObservableObject {
    @Published var title: String
    @Published var btnTitle: String
    @Published var body: String
    @Published var entity: GitHubPullRequest
    
    init(entity: GitHubPullRequest) {
        self.title = "PR #\(entity.number)"
        self.btnTitle = .localize(.viewDiff)
        self.body = entity.body ?? ""
        self.entity = entity
    }
}
