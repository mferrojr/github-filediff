//
//  GitHubPRResponse.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct GitHubPRResponse: Identifiable {
    
    // MARK: - Properties
    let id: Int
    let number: Int
    let diff_url: String
    let state: String
    let title: String
    let body: String
    let created_at: String
    let user: GitHubUserResponse

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
    
    func toModel() -> GitHubPullRequest {
        return GitHubPullRequest(
            id: self.id,
            body: self.body,
            created_at: self.created_at,
            diff_url: self.diff_url,
            number: self.number,
            state: self.state,
            title: self.title,
            user: self.user.toModel()
        )
    }
}
