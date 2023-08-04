//
//  SceneDelegate.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 18.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        if let _ = AuthService.shared.currentUser {
            let viewController = HomeViewController()
            let navController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navController
        } else {
            let viewController = OnboardingModuleAssembly.configureModule()
            let navController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navController
        }
        
        window?.makeKeyAndVisible()
    }
}
