//
//  RepoSearchView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI

struct RepoSearchView: View {
    // MARK: - Properties
    weak var coordinator: MainCoordinator?
    @StateObject var viewModel: RepoSearchViewModel
    @StateObject var textObserver = TextFieldObserver()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField(String.localize(.searchForRepository), text: $textObserver.searchText)
                        .onChange(of: textObserver.debouncedText) {
                            viewModel.searchRepos(with: textObserver.debouncedText)
                        }
                }
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 5, trailing: 8))
                contentView
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /// Main content
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .initial:
            Spacer()
        case .loading:
            LoadingView()
        case .loaded(let items):
            if items.isEmpty {
                ContentUnavailableView.search
            } else {
                RepoListView(coordinator: coordinator, items: items)
            }
        case .error:
            ErrorView(text: "Error retrieving repositories.", imageSystemName: "exclamationmark.transmission")
        }
    }
    
    /// Displays all repositories
    struct RepoListView: View {
        // MARK: - Properties
        let coordinator: MainCoordinator?
        let items: [GitHubRepo]
        
        var body: some View {
            List(items) { item in
                RepoView(item: item)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        coordinator?.navigate(to: .pullRequests(repo: item))
                    }
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
