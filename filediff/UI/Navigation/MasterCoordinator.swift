//
//  MasterCoordinator.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 5/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

final class RootMasterCoordinator: Coordinator {
    
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
