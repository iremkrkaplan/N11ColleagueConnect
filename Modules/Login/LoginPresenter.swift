//
//  LoginPresenter.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 10.09.2025.
//

import Foundation

final class LoginPresenter: LoginPresenterInput {
    
    weak var view: LoginViewInput?
    var interactor: LoginInteractorInput?
    var router: LoginRouterInput?
    
    init(view: LoginViewInput,
         interactor: LoginInteractorInput,
         router: LoginRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.displayLoading()
        interactor?.generateAuthorizationURL()
    }
    
    func didCapture(code: String) {
        view?.displayLoading()
        interactor?.exchangeCodeForToken(code: code)
    }
}

extension LoginPresenter: LoginInteractorOutput {
    
    func didGenerateAuthorizationURL(_ url: URL) {
        let viewData = LoginViewData(
            githubLoginURL: url,
            customURLScheme: "n11peopleproject",
            codeQueryItemName: "code",
            loginButtonModel: NavigateToGitHubButtonPresentationModel(title: "", url: nil, action: {}),
            infoTitleText: ""
        )
        view?.bind(viewData: viewData)
        view?.load(url: url)
    }
    
    func didSuccessfullyAuthenticate() {
        router?.loginDidSucceed()
    }
}

/*import Foundation

final class LoginPresenter: LoginPresenterInput {
    
    weak var view: LoginViewInput?
    var interactor: LoginInteractorInput?
    var router: LoginRouterInput?
    
    init(view: LoginViewInput,
         interactor: LoginInteractorInput,
         router: LoginRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        let viewData = createLoginViewData()
        view?.bind(viewData: viewData)
    }
    
    func didCapture(code: String) {
        view?.displayLoading()
        interactor?.exchangeCodeForToken(code: code)
    }
    
    func retryButtonTapped() {
        viewDidLoad()
    }
}

extension LoginPresenter: LoginInteractorOutput {
    
    func didGenerateAuthorizationURL(_ url: URL) {
        view?.load(url: url)
    }
    
    func didSuccessfullyAuthenticate() {
        router?.loginDidSucceed()
    }
}

private extension LoginPresenter {
    
    func createLoginViewData() -> LoginViewData {
        let loginButtonAction: () -> Void = { [weak self] in
            self?.interactor?.generateAuthorizationURL()
        }
        
        let loginButtonModel = NavigateToGitHubButtonPresentationModel(
            title: "GitHub ile Giriş Yap",
            url: nil,
            action: loginButtonAction
        )
        
        return LoginViewData(
            githubLoginURL: URL(string: "about:blank")!,
            customURLScheme: "n11peopleproject",
            codeQueryItemName: "code",
            loginButtonModel: loginButtonModel,
            infoTitleText: "GitHub hesabınızla giriş yaparak devam edin"
        )
    }
}
*/
