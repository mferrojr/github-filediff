//
//  AppCoordinator.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 5/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    private weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let coordinator = RootMasterCoordinator(window: window)
        coordinate(to: coordinator)
    }
}
