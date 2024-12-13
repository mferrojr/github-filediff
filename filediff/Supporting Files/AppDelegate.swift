//
//  AppDelegate.swift
//  filediff
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = DBManager(storageContext: CoreDataStorageContext())
        setupDependencyContainer()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

// MARK: - Private Functions
private extension AppDelegate {
    
    func setupDependencyContainer() {
        ServiceContainer.register(type: GitHubDataSource.self, GitHubRemoteDataSource())
        ServiceContainer.register(type: GitHubRepoRepository.self, GitHubRepoRepositoryImpl())
        ServiceContainer.register(type: GitHubPRRepository.self, GitHubPRRepositoryImpl())
    }
}
