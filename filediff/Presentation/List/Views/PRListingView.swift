//
//  PRListingView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import SwiftUI

struct PRListingView: View {
    
    var coordinator: MainCoordinator?
    @StateObject var viewModel: PRListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                contentView
            }
            .task {
                viewModel.refreshData()
            }
            .refreshable {
                viewModel.refreshData()
            }
        }
        .navigationTitle(viewModel.navTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.state {
        case .initial:
            Spacer()
        case .loading:
            LoadingView()
        case .loaded(let items):
            if items.isEmpty {
                emptyListView
            } else {
                PRListView(items: items, coordinator: coordinator)
            }
        case .error:
            ErrorView(text: "Error retrieving pull requests.", imageSystemName: "exclamationmark.transmission")
        }
    }
    
    var emptyListView: some View {
        Label {
            Text("No open pull requests.")
        } icon: {
            Image(systemName: "checkmark.seal.text.page.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.green)
        }
    }
}

struct PRListView: View {
    let items: [GitHubPullRequest]
    let coordinator: MainCoordinator?
    private let kSpacing: CGFloat = 8
    
    var body: some View {
        List(items) { entity in
            HStack {
                Image(systemName: "arrowshape.turn.up.left.2.circle")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.green)
                PRRowView(model: PRRowViewModel(entity: entity))
                    .onTapGesture {
                        coordinator?.viewPullRequestDetailsBy(entity: entity)
                    }
            }
            .listRowInsets(.init(top: kSpacing, leading: kSpacing, bottom: kSpacing, trailing: kSpacing))
        }
    }
}

struct PRListView_Previews: PreviewProvider {
    struct GitHubPRRepositoryMock: GitHubPRRepository {
        func pullRequests(for repo: GitHubRepo) -> AnyPublisher<[GitHubPullRequest], any Error> {
            let user = GitHubRepoOwner(
                id: 0, login: "login", avatarUrl: URL(string: "https://developer.apple.com/assets/elements/icons/swiftui/swiftui-96x96_2x.png")!)
            let pr = GitHubPullRequest(id: 0, body: "body", created_at: "created_at", diff_url: "diff_url", number: 2, state: "state", title: "title", user: user)
            return Just([pr])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func pullRequestBy(diffUrl: URL) -> AnyPublisher<String, any Error> {
            Just(String())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    static var previews: some View {
        let repo = GitHubRepo(id: 1, name: "Name", fullName: "Full Name")
        let vm = PRListViewModel(repo: repo, prRepo: GitHubPRRepositoryMock())
        return PRListingView(viewModel: vm)
    }
}
