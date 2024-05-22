//
//  SceneDelegate.swift
//  RealEstate
//
//  Created by Ramzan on 18.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = LoginViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}

