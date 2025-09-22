//
//  AppLoader.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 18.08.2025.
//

import UIKit

public final class AppLoader {
    private let router: AppRouter
    
    public init(window: UIWindow) {
        self.router = AppRouter(window: window)
    }
    public func load() {
        router.start()
    }
}
