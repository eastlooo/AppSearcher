//
//  SceneDelegate.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/11.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.tintColor = .primary
        let viewModel = MainViewModel()
        let rootViewController = MainViewController(viewModel: viewModel)
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.navigationBar.isHidden = true
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

