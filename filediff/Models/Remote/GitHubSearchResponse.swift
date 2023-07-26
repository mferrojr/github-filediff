//
//  GitHubSearchResponse.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 7/25/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubSearchResponse {
    var items: [GitHubRepoResponse]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init() {
        items = []
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
    
    func toEntity() -> GitHubSearchEntity {
        return GitHubSearchEntity(items: items.map { $0.toEntity()} )
    }
}

