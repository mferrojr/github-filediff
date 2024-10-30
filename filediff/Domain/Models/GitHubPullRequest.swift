//
//  GitHubPullRequest.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubPullRequest: Identifiable {
    let id: Int
    let body: String?
    let created_at: String?
    let diff_url: String
    let number: Int
    let state: String?
    let title: String?
    let user: GitHubRepoOwner?
}
