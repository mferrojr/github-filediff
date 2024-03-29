//
//  RepoView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 7/26/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

import SwiftUI

struct RepoView: View {
    let item: GitHubRepoEntity
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .bold()
                .font(.system(size:17))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }
}

struct RepoView_Previews: PreviewProvider {
    static var previews: some View {
        RepoView(item: GitHubRepoEntity(id: 1, name: "Test Name", fullName: "Full Name"))
    }
}
