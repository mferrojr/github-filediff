//
//  MainCoordinator.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/27/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    
    // MARK: - Variables
    
    // MARK: Private
    private var childCoordinators = [Coordinator]()
    private var navigationController: UINavigationController

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Functions
    
    // MARK: Public
    func start() {
        let vc = PRListViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func viewPullRequestDetailsBy(entity: GitHubPREntity) {
        let vc = PRDetailsViewController(entity: entity)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func viewPullRequestDiff(entity: GitHubPREntity) {
        let vc = PRDiffViewController(entity: entity)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
}
