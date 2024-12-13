//
//  AppCoordinator.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

/// Entry point for app navigation
final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    // MARK: Private
    private weak var window: UIWindow?
    private var rootCoordinator: Coordinator?
    
    // MARK: - Initialization
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Functions
    func start() {
        self.rootCoordinator = PrimaryCoordinator(window: window)
        self.rootCoordinator?.start()
    }
}
