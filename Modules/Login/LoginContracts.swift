//
//  LoginContracts.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 10.09.2025.
//

import UIKit

protocol LoginViewInput: AnyObject {
    var output: LoginViewOutput? { get set }
    func load(url: URL)
    func bind(viewData: LoginViewData)
    func displayLoading()
}

protocol LoginViewOutput: AnyObject {
    func viewDidLoad()
    func didCapture(code: String)
}

protocol LoginPresenterInput: LoginViewOutput, LoginInteractorOutput {
    var view: LoginViewInput? { get set }
    var interactor: LoginInteractorInput? { get set }
    var router: LoginRouterInput? { get set }
}

protocol LoginInteractorInput: AnyObject {
    var output: LoginInteractorOutput? { get set }
    func generateAuthorizationURL()
    func exchangeCodeForToken(code: String)
}

protocol LoginInteractorOutput: AnyObject {
    func didGenerateAuthorizationURL(_ url: URL)
    func didSuccessfullyAuthenticate()
}

protocol LoginRouterInput: AnyObject {
    var viewController: UIViewController? { get set }
    func loginDidSucceed()
}

protocol LoginRouterDelegate: AnyObject {
    func loginFlowDidComplete()
}
