//
//  GitHubSearchResponse.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubSearchResponse {
    let items: [GitHubRepoResponse]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init(items: [GitHubRepoResponse] = []) {
        self.items = items
    }
}

// MARK: - Decodable
extension GitHubSearchResponse: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([GitHubRepoResponse].self, forKey: .items)
    }

}

extension GitHubSearchResponse {
    
    func toModel() -> GitHubSearch {
        return GitHubSearch(items: items.map { $0.toModel()} )
    }
}

