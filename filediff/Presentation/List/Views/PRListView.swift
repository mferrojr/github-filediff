//
//  PRListView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import SwiftUI

struct PRListView: View {
    
    var coordinator: MainCoordinator?
    @StateObject var viewModel: PRListViewModel
    
    private let kSpacing: CGFloat = 8
    
    var body: some View {
        NavigationStack {
            VStack {
                listView
            }
            .refreshable {
                viewModel.refreshData()
            }
        }
        .navigationTitle(viewModel.navTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    var listView: some View {
        if viewModel.error != nil {
            errorView
        } else if viewModel.entities.isEmpty {
            emptyListView
        } else {
            objectsListView
        }
    }
    
    var errorView: some View {
        Label {
            Text("Error retrieving pull requests.")
        } icon: {
            Image(systemName: "exclamationmark.transmission")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.red)
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

    var objectsListView: some View {
        List(viewModel.entities) { entity in
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
    struct GitHubPRRepositoryLocal: GitHubPRRepository {
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
        let vm = PRListViewModel(repo: repo, prRepo: GitHubPRRepositoryLocal())
        return PRListView(viewModel: vm)
    }
}
