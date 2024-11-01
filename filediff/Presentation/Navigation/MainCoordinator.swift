//
//  MainCoordinator.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import UIKit
import SwiftUI

enum Route {
    case pullRequests(repo: GitHubRepo)
    case pullRequestDetails(entity: GitHubPullRequest)
    case pullRequestDiff(entity: GitHubPullRequest)
}
@MainActor
final class MainCoordinator: Coordinator {
    
    // MARK: - Properites
    
    // MARK: Private
    private var childCoordinators = [Coordinator]()
    private var navigationController: UINavigationController

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Functions
    func start() {
        let searchView = RepoSearchView(coordinator: self, viewModel: RepoSearchViewModel())
        self.push(searchView)
    }

    func navigate(to route: Route) {
        switch route {
        case .pullRequests(let repo):
            viewPullRequestsFor(repo: repo)
        case .pullRequestDetails(let entity):
            viewPullRequestDetailsBy(entity: entity)
        case .pullRequestDiff(let entity):
            viewPullRequestDiff(entity: entity)
        }
    }
}

// MARK: - Private Functions
private extension MainCoordinator {
    
    /// Navigate to viewing pull requests
    func viewPullRequestsFor(repo: GitHubRepo) {
        let listView = PRListingView(coordinator: self, viewModel: PRListViewModel(repo: repo))
        self.push(listView)
    }
    
    /// Navigate to pull request details
    func viewPullRequestDetailsBy(entity: GitHubPullRequest) {
        let detailsView = PRDetailsView(coordinator: self, viewModel: PRDetailsViewModel(entity: entity))
        self.push(detailsView)
    }
    
    /// Navigate to pull request diff
    func viewPullRequestDiff(entity: GitHubPullRequest) {
        let vc = PRDiffViewController(diffUrl: entity.diff_url)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    /// Pushs views onto the nav controller
    /// - Parameters:
    ///  - view: view to be pushed
    ///  - animated: if transistion is animated
    func push<T: View>(_ view: T, animated: Bool = true) {
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: animated)
    }
}
