//
//  PrimaryCoordinator.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

/// Entry point for app navigation
@MainActor
final class PrimaryCoordinator: Coordinator {
    
    // MARK: - Properties
    
    // MARK: Private
    private weak var window: UIWindow?
    private var mainCoordinator: Coordinator?
    
    // MARK: - Initialization
    init(window: UIWindow?) {
        self.window = window
    }
    
    // MARK: - Functions
    func start() {
        let navController = UINavigationController()
        self.mainCoordinator = MainCoordinator(navigationController: navController)
        self.mainCoordinator?.start()
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
}
