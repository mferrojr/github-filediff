//
//  RepoView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI

/// Displays repository details
struct RepoView: View {
    // MARK: - Properties
    let item: GitHubRepo
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.fullName)
                .bold()
                .font(.system(size:17))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }
}

struct RepoView_Previews: PreviewProvider {
    static var previews: some View {
        RepoView(item: GitHubRepo(id: 1, name: "Test Name", fullName: "Full Name"))
    }
}
