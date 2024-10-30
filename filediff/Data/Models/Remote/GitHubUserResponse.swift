//
//  GitHubUserResponse.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubUserResponse {
    
    // MARK: - Properties
    let id: Int
    let login: String
    let avatar_url: URL

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatar_url
    }
}

// MARK: - Decodable
extension GitHubUserResponse: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        login = try container.decode(String.self, forKey: .login)
        avatar_url = try container.decode(URL.self, forKey: .avatar_url)
    }

}

extension GitHubUserResponse {
    
    func toModel() -> GitHubRepoOwner {
        return GitHubRepoOwner(
            id: self.id,
            login: self.login,
            avatarUrl: self.avatar_url
        )
    }
}
