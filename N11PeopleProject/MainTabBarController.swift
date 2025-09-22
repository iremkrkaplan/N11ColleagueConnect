//
//  MainTabBarController.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 1.09.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let appRouter: AppRouter
    
    init(appRouter: AppRouter) {
        self.appRouter = appRouter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        self.tabBar.tintColor = .systemPurple
        self.tabBar.backgroundColor = .systemBackground
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTabs() {
        
        struct TabBarItem {
            let viewController: UIViewController
            let title: String
            let icon: UIImage?
            let selectedIcon: UIImage?
        }
        let tabItems: [TabBarItem] = [
            .init(
                viewController: appRouter.buildDashboardFeature(),
                title: "Ana Sayfa",
                icon: UIImage(systemName: "house"),
                selectedIcon: UIImage(systemName: "house.fill")
            ),
            .init(
                viewController: appRouter.buildUserListFeature(),
                title: "Arama",
                icon: UIImage(systemName: "magnifyingglass"),
                selectedIcon: UIImage(systemName: "magnifyingglass")
            ),
            .init(
                viewController: appRouter.buildUserFavoritesFeature(),
                title: "Favorilerim",
                icon: UIImage(systemName: "heart"),
                selectedIcon: UIImage(systemName: "heart.fill")
            ),
            .init(
                viewController: appRouter.buildDashboardFeature(),
                title: "Hesabım",
                icon: UIImage(systemName: "person"),
                selectedIcon: UIImage(systemName: "person.fill")
            )
        ]
        
        let viewControllers = tabItems.map { item -> UIViewController in
            let vc = item.viewController
            vc.tabBarItem = UITabBarItem(
                title: item.title,
                image: item.icon,
                selectedImage: item.selectedIcon
            )
            return UINavigationController(rootViewController: vc)
        }
        
        self.setViewControllers(viewControllers, animated: false)
    }
}
