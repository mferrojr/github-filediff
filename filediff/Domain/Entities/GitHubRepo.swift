//
//  GitHubRepoEntity.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubRepo: Identifiable, Equatable {
    let id: Int
    let name: String
    let fullName: String
}
