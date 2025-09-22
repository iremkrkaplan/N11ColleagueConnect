//
//  LoginRouter.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 10.09.2025.
//

// LoginRouter.swift (Güncellenmiş Hali - Yeni createLoginModule metodunu ekleyeceğiz)
import UIKit

final class LoginRouter: LoginRouterInput {
    
    var viewController: UIViewController?
    weak var delegate: LoginRouterDelegate?
    
    static func createLoginModule(delegate: LoginRouterDelegate?) -> UIViewController {
        let view = LoginViewController()
        let interactor = LoginInteractor(apiClient: .live)
        let router = LoginRouter()
        router.delegate = delegate
        
        let presenter = LoginPresenter(view: view, interactor: interactor, router: router)
        view.output = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func loginDidSucceed() {
        delegate?.loginFlowDidComplete()
    }
}
/*

import UIKit

final class LoginRouter: LoginRouterInput {
    
    var viewController: UIViewController?
    weak var delegate: LoginRouterDelegate?
    
    static func createModule(delegate: LoginRouterDelegate?) -> UIViewController {
        let view = LoginViewController()
        let interactor = LoginInteractor(apiClient: .live)
        let router = LoginRouter()
        router.delegate = delegate
        
        let presenter = LoginPresenter(view: view, interactor: interactor, router: router)
        view.output = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func loginDidSucceed() {
        delegate?.loginFlowDidComplete()
    }
}
*/
