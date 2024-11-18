//
//  PRRowViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI

final class PRRowViewModel: ObservableObject {
    @Published private(set) var title: String
    @Published private(set) var prTitle: String
    @Published private(set) var userTitle: String = ""
    @Published private(set) var avatarUrl: URL?
    
    // MARK: - Initialization
    init(entity: GitHubPullRequest) {
        self.title = entity.title
        self.prTitle = "#\(entity.number) opened by"
        self.userTitle = entity.user?.login ?? "N/A"
        self.avatarUrl = entity.user?.avatarUrl
    }
}
