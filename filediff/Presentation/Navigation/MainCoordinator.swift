//
//  MainCoordinator.swift
//  filediff
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import UIKit
import SwiftUI

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
        let view = UIHostingController(rootView: searchView)
        navigationController.pushViewController(view, animated: false)
    }
    
    func viewPullRequestsFor(repo: GitHubRepo) {
        let listView = PRListingView(coordinator: self, viewModel: PRListViewModel(repo: repo))
        let view = UIHostingController(rootView: listView)
        navigationController.pushViewController(view, animated: false)
    }
    
    func viewPullRequestDetailsBy(entity: GitHubPullRequest) {
        let detailsView = PRDetailsView(coordinator: self, viewModel: PRDetailsViewModel(entity: entity))
        let view = UIHostingController(rootView: detailsView)
        navigationController.pushViewController(view, animated: false)
    }
    
    func viewPullRequestDiff(entity: GitHubPullRequest) {
        let vc = PRDiffViewController(diffUrl: entity.diff_url)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
}
