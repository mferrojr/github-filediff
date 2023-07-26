//
//  GitHubRepoResponse.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 7/25/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubRepoResponse {
    var id: Int
    var name: String
    var full_name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case full_name
    }
}

// MARK: - Decodable
extension GitHubRepoResponse: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        full_name = try container.decode(String.self, forKey: .full_name)
    }

}

extension GitHubRepoResponse {
    
    func toEntity() -> GitHubRepoEntity {
        return GitHubRepoEntity(id: self.id, name: self.name, fullName: self.full_name)
    }
}
