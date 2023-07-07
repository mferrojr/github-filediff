//
//  GitHubPRResponse.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 3/30/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubPRResponse: Identifiable {
    
    // MARK: - Properties
    var id: Int
    var number: Int
    var diff_url: String
    var state: String
    var title: String
    var body: String
    var created_at: String
    var user: GitHubUserResponse

    enum CodingKeys: String, CodingKey {
        case id
        case number
        case diff_url
        case state
        case title
        case body
        case created_at
        case user
    }
}

// MARK: - Decodable
extension GitHubPRResponse: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        number = try container.decode(Int.self, forKey: .number)
        diff_url = try container.decode(String.self, forKey: .diff_url)
        state = try container.decode(String.self, forKey: .state)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        created_at = try container.decode(String.self, forKey: .created_at)
        user = try container.decode(GitHubUserResponse.self, forKey: .user)
    }

}

extension GitHubPRResponse {
    
    func toEntity() -> GitHubPREntity {
        let entity = GitHubPREntity()
        entity.id = self.id
        entity.number = self.number
        entity.diff_url = self.diff_url
        entity.state = self.state
        entity.title = self.title
        entity.body = self.body
        entity.created_at = self.created_at
        entity.user = self.user.toEntity()
        return entity
    }
}
