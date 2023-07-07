//
//  MainCoordinator.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/27/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import UIKit
import SwiftUI

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
        let listView = PRListView(coordinator: self, viewModel: PRListViewModel())
        let view = UIHostingController(rootView: listView)
        navigationController.pushViewController(view, animated: false)
    }
    
    func viewPullRequestDetailsBy(entity: GitHubPREntity) {
        let detailsView = PRDetailsView(model: PRDetailsViewModel(entity: entity), coordinator: self)
        let view = UIHostingController(rootView: detailsView)
        navigationController.pushViewController(view, animated: false)
    }
    
    func viewPullRequestDiff(entity: GitHubPREntity) {
        let vc = PRDiffViewController(entity: entity)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
}
