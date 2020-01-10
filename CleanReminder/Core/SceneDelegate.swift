//
//  SceneDelegate.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 01.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = RootViewController(persistentContainer: AppModel.shared.persistentContainer)
        self.window?.makeKeyAndVisible()
    }
    
}

