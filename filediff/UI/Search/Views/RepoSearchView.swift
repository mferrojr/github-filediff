//
//  RepoSearchView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 7/25/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

import SwiftUI

struct RepoSearchView: View {
    var coordinator: MainCoordinator?
    @StateObject var viewModel: RepoSearchViewModel
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField(String.localize(.searchForRepository), text: $name)
                    .onChange(of: name) { newValue in
                        viewModel.searchRepos(with: name)
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                List(viewModel.items) { item in
                    RepoView(item: item)
                        .onTapGesture {
                            coordinator?.viewPullRequestsFor(repo: item)
                        }
                }
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RepoSearchView_Previews: PreviewProvider {
    static var previews: some View {
        let entity = GitHubPREntity(body: "body", title: "title", number: 5)
        let model = PRDetailsViewModel(entity: entity)
        PRDetailsView(viewModel: model)
    }
}
