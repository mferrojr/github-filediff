//
//  GitHubParserOperation.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

final class GitHubParserOperation : BaseOperation, @unchecked Sendable {
    
    // MARK: - Properties
    
    // MARK: Private
    private var context : FileDiffQueueContext!
    
    // MARK: - Initialization
    required init(context : FileDiffQueueContext) {
        self.context = context
    }
    
    // MARK: - Functions
    override func main() {
        super.main()
        
        guard let fileText = self.context.fileText else {
            self.errorCB(nil)
            return
        }
        
        context.files = GitHubParser.parse(fileText: fileText)
        
        self.done()
    }
    
}
