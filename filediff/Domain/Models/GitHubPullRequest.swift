//
//  GitHubPR.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubPR {
    let body: String?
    let created_at: String?
    let diff_url: String
    let id: Int32
    let number: Int32
    let state: String?
    let title: String?
    let user: GitHubUser?
}
