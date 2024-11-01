//
//  GitHubRepoResponse.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubRepoResponse {
    let id: Int
    let name: String
    let full_name: String
    
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
    
    func toModel() -> GitHubRepo {
        return GitHubRepo(id: self.id, name: self.name, fullName: self.full_name)
    }
}
