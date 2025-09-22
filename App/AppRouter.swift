//
//  AppRouter.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 18.08.2025.
//

import UIKit
import KeychainSwift

final class AppRouter: LoginRouterDelegate, WelcomeViewDelegate, DashboardRouterDelegate {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let keychain = KeychainSwift()
        let accessToken = keychain.get("github_access_token")

        if accessToken != nil {
            showMainInterface()
        } else {
            showWelcomeScreen()
        }
    }
    
    private func showWelcomeScreen() {
        let welcomeVC = WelcomeViewController()
        welcomeVC.delegate = self
        let navigationController = UINavigationController(rootViewController: welcomeVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showLoginScreen() {
        let loginViewController = LoginRouter.createLoginModule(delegate: self)
        
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.present(loginViewController, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: loginViewController)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
    private func showMainInterface() {
        let mainTabBarController = MainTabBarController(appRouter: self)
        window.rootViewController = mainTabBarController
        window.makeKeyAndVisible()
    }
    
    func loginFlowDidComplete() {
        DispatchQueue.main.async {
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.dismiss(animated: true)
                self.showMainInterface()
                UIView.transition(with: self.window, duration: 0.3, options: .transitionFlipFromRight, animations: nil)
            } else {
                self.showMainInterface()
                UIView.transition(with: self.window, duration: 0.3, options: .transitionFlipFromRight, animations: nil)
            }
        }
    }
    
    func logout() {
        let keychain = KeychainSwift()
        keychain.delete("github_access_token")
        
        DispatchQueue.main.async {
            let welcomeVC = WelcomeViewController()
            welcomeVC.delegate = self
            let navigationController = UINavigationController(rootViewController: welcomeVC)
            self.window.rootViewController = navigationController
            self.window.makeKeyAndVisible()
        }
    }
    
    func didTapLoginButton() {
        showLoginScreen()
    }
    
    func buildDashboardFeature() -> UIViewController {
        return DashboardRouter.createModule(delegate: self)
    }
    
    func buildUserListFeature() -> UIViewController {
        return UserListRouter.createModule()
    }
    
    func buildUserFavoritesFeature() -> UIViewController {
        return UserFavoritesRouter.createModule()
    }
    
    func buildMainInterface() -> UIViewController {
        return MainTabBarController(appRouter: self)
    }
}

/*
import UIKit
import KeychainSwift
final class AppRouter: LoginRouterDelegate {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let keychain = KeychainSwift()
        let accessToken = keychain.get("github_access_token")

        if accessToken != nil {
            showMainInterface()
        } else {
            showLoginScreen()
        }
    }
    
    private func showLoginScreen() {
        let loginViewController = LoginRouter.createModule(delegate: self)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showMainInterface() {
        let mainTabBarController = MainTabBarController(appRouter: self)
        window.rootViewController = mainTabBarController
        window.makeKeyAndVisible()
    }
    
    func loginFlowDidComplete() {
        showMainInterface()
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight, animations: nil)
    }
    
    func buildDashboardFeature() -> UIViewController {
        return DashboardRouter.createModule()
    }
    
    func buildUserListFeature() -> UIViewController {
        return UserListRouter.createModule()
    }
    
    func buildUserFavoritesFeature() -> UIViewController {
        return UserFavoritesRouter.createModule()
    }
    
    func buildMainInterface() -> UIViewController {
        return MainTabBarController(appRouter: self)

    }
}
*/
