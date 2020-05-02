//
//  SceneDelegate.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/27/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var mainCoordinator: MainCoordinator!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        let coordinator = AppCoordinator(window: window)
        coordinator.start()
        self.window = window
    }

}
