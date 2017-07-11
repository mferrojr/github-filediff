//
//  SyncPRsOperation.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

class SyncPRsOperation : BaseOperation {
    
    override func main() {
        super.main()
        getPRs()
    }
    
    private func getPRs(){
        GitHubService.getPullRequests(successCB, errorCB: errorCB)
    }
    
    private func successCB(_ response : [RealmGitHubPR]) {
        self.saveArrayToRealm(response)
    }
    
    private func errorCB(_ error : Error?, code : Int?) {
        self.errorCallback?(error,code)
    }

}
