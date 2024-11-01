//
//  PRRowViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI

final class PRRowViewModel: ObservableObject {
    @Published var title: String
    @Published var prTitle: String
    @Published var userTitle: String = ""
    @Published var avatarUrl: URL?
    
    // MARK: - Initialization
    init(entity: GitHubPullRequest) {
        self.title = entity.title ?? ""
        self.prTitle = "#\(entity.number) opened by"
        self.userTitle = entity.user?.login ?? "N/A"
        self.avatarUrl = entity.user?.avatarUrl
    }
}
