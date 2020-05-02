//
//  GitHubParserOperation.swift
//  filediff
//
//  Created by bn-user on 7/25/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

class GitHubParserOperation : BaseOperation {
    
    // MARK: - Variables
    
    // MARK: Private
    private var context : FileDiffQueueContext!
    
    // MARK: - Initialization
    required init(context : FileDiffQueueContext) {
        self.context = context
    }
    
    // MARK: - Functions
    
    // MARK: Public
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
