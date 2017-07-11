//
//  ArrayExtensions.swift
//  filediff
//
//  Created by Michael Ferro on 7/11/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

extension Array where Element : GitHubRealmBase {
    
    func getIds() -> [String] {
        return self.map { $0.id }
    }
    
}
