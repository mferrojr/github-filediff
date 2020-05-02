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
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let navController = UINavigationController()
        let mainCoordinator = MainCoordinator(navigationController: navController)
        mainCoordinator.start()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
