//
//  GitRepoOwner.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubRepoOwner: Identifiable {
    let id: Int
    let login: String
    let avatarUrl: URL
}
