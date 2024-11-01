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
    @Published private(set) var title: String
    @Published private(set) var btnTitle: String
    @Published private(set) var body: String
    @Published private(set) var entity: GitHubPullRequest
    
    init(entity: GitHubPullRequest) {
        self.title = "PR #\(entity.number)"
        self.btnTitle = "View PR Diff"
        self.body = entity.body ?? ""
        self.entity = entity
    }
}
