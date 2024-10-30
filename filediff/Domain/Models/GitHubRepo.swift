//
//  GitHubRepoEntity.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubRepo: Identifiable {
    let id: Int
    let name: String
    let fullName: String
}
