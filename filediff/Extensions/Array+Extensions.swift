//
//  ArrayExtensions.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

extension Array where Element : GitHubIdentifible {
    
    func getIds() -> [Int] {
        return self.map { Int($0.id) }
    }
    
}
