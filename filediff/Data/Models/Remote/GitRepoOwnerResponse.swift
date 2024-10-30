//
//  GitRepoOwnerResponse.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitRepoOwnerReponse {
    let id: Int
    let avatar_url: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case avatar_url
    }
}

// MARK: - Decodable
extension GitRepoOwnerReponse: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        avatar_url = try container.decode(URL.self, forKey: .avatar_url)
    }

}

extension GitRepoOwnerReponse {
    
    func toEntity() -> GitHubRepoOwnerEntity {
        return GitHubRepoOwnerEntity(id: self.id, avatarUrl: self.avatar_url)
    }
}
