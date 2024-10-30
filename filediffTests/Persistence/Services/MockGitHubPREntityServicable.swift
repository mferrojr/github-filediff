//
//  MockGitHubPREntityServicable.swift
//  filediffTests
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
@testable import PR_Diff_Tool

struct MockGitHubPREntityServicable: GitHubPREntityRepository {
    
    func createAllPRs(entities: [GitHubPREntity]) throws {
    }
    
    func createPR(entity: GitHubPREntity) throws {
    }
    
    func updatePR(entity: GitHubPREntity) throws {
    }
    
    func fetchBy(prNumber: Int) -> GitHubPREntity? {
        return nil
    }
    
    func fetchAll(sorted: Sorted?) -> [GitHubPREntity] {
        let instance0 = GitHubPREntity()
        instance0.number = 0
        
        let instance1 = GitHubPREntity()
        instance1.number = 1
        
        return [instance0, instance1]
    }
    
    
}
