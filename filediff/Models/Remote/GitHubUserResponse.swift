//
//  GitHubUserResponse.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 3/30/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

struct GitHubUserResponse {
    var id: Int
    var login: String
    var avatar_url: String

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
        avatar_url = try container.decode(String.self, forKey: .avatar_url)
    }

}

extension GitHubUserResponse {
    
    func toEntity() -> GitHubUserEntity {
        let entity = GitHubUserEntity()
        entity.id = self.id
        entity.login = self.login
        entity.avatar_url = self.avatar_url
        return entity
    }
}
