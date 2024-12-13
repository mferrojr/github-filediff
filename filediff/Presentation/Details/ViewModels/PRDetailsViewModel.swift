//
//  PRDetailsViewModel.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class PRDetailsViewModel {
    private(set) var title: String
    private(set) var btnTitle: String
    private(set) var body: String
    private(set) var entity: GitHubPullRequest
    
    init(entity: GitHubPullRequest) {
        self.title = "PR #\(entity.number)"
        self.btnTitle = "View PR Diff"
        self.body = entity.body ?? ""
        self.entity = entity
    }
}
