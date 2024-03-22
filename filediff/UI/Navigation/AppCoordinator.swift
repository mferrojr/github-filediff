//
//  AppCoordinator.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 5/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

@MainActor
final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    // MARK: Private
    private weak var window: UIWindow?
    private var rootMasterCoordinator: Coordinator?
    
    // MARK: - Initialization
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Functions
    func start() {
        self.rootMasterCoordinator = RootMasterCoordinator(window: window)
        self.rootMasterCoordinator?.start()
    }
}
