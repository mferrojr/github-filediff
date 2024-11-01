//
//  GitRepoOwnerResponse.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitRepoOwnerReponse {
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
extension GitRepoOwnerReponse: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        login = try container.decode(String.self, forKey: .login)
        avatar_url = try container.decode(URL.self, forKey: .avatar_url)
    }

}

extension GitRepoOwnerReponse {
    
    func toModel() -> GitHubRepoOwner {
        return GitHubRepoOwner(id: self.id, login: self.login, avatarUrl: self.avatar_url)
    }
}
