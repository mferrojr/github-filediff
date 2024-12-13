//
//  PRRowViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI
import Observation

@Observable
final class PRRowViewModel {
    private(set) var title: String
    private(set) var prTitle: String
    private(set) var userTitle: String = ""
    private(set) var avatarUrl: URL?
    
    // MARK: - Initialization
    init(entity: GitHubPullRequest) {
        self.title = entity.title
        self.prTitle = "#\(entity.number) opened by"
        self.userTitle = entity.user?.login ?? "N/A"
        self.avatarUrl = entity.user?.avatarUrl
    }
}
