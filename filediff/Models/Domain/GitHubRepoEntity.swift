//
//  GitHubRepoEntity.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 7/25/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubRepoEntity: Identifiable {
    var id: Int
    var name: String
    var fullName: String
}
