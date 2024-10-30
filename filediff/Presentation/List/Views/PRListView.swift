//
//  PRListView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI

struct PRListView: View {
    
    var coordinator: MainCoordinator?
    @StateObject var viewModel: PRListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.entities) { entity in
                    PRRowView(model: PRRowViewModel(entity: entity))
                    .onTapGesture {
                        coordinator?.viewPullRequestDetailsBy(entity: entity)
                    }
                }
            }
            .refreshable {
                viewModel.refreshData()
            }
        }
        .navigationTitle(viewModel.repo.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PRListView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = GitHubRepoEntity(id: 1, name: "Name", fullName: "Full Name")
        var entities = [GitHubPREntity]()
        let entity = GitHubPREntity(body: "body", title: "title", number: 5)
        entities.append(entity)
        let vm = PRListViewModel(repo: repo, entities: entities)
        return PRListView(viewModel: vm)
    }
}
