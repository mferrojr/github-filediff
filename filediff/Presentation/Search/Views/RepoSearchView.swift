//
//  RepoSearchView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI

struct RepoSearchView: View {
    var coordinator: MainCoordinator?
    @StateObject var viewModel: RepoSearchViewModel
    @StateObject var textObserver = TextFieldObserver()
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField(String.localize(.searchForRepository), text: $textObserver.searchText)
                        .onChange(of: textObserver.debouncedText) {
                            viewModel.searchRepos(with: textObserver.debouncedText)
                        }
                }
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 5, trailing: 8))
                listView
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    var listView: some View {
        if viewModel.error != nil {
            errorView
        } else if viewModel.items.isEmpty &&    !textObserver.debouncedText.isEmpty &&
            !viewModel.isLoading {
            emptyListView
        } else {
            objectsListView
        }
    }
    
    var errorView: some View {
        Label {
            Text("Error retrieving repositories.")
        } icon: {
            Image(systemName: "exclamationmark.transmission")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.red)
        }
    }
    
    var emptyListView: some View {
        VStack {
            Label {
                Text("No repositories found.")
            } icon: {
                Image(systemName: "minus.magnifyingglass")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.green)
            }
            .padding(8)
            Spacer()
        }
    }
    
    var objectsListView: some View {
        List(viewModel.items) { item in
            RepoView(item: item)
                .onTapGesture {
                    coordinator?.viewPullRequestsFor(repo: item)
                }
        }
    }
}

struct RepoSearchView_Previews: PreviewProvider {
    static var previews: some View {
        let entity = GitHubPullRequest(
            id: 0,
            body: "body",
            created_at: "created_at",
            diff_url: "diff_url",
            number: 3,
            state: "state",
            title: "title",
            user: nil)
        let model = PRDetailsViewModel(entity: entity)
        PRDetailsView(viewModel: model)
    }
}
