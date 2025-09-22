//
//  UserFavoritesRouter.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 8.09.2025.
//
import UIKit

final class UserFavoritesRouter: UserFavoritesRouterInput {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        
        let view: UserFavoritesViewInput & UIViewController = UserFavoritesViewController()
        
        let interactor: UserFavoritesInteractorInput = UserFavoritesInteractor(apiClient: .live)
        
        let router: UserFavoritesRouterInput = UserFavoritesRouter()
        
        let presenter: UserFavoritesPresenterInput & UserFavoritesInteractorOutput = UserFavoritesPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        view.output = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        
        router.viewController = view
        
        return view
    }
    
    func navigateToUserDetail(username: String) {
        guard let sourceView = viewController else { return }
        let detailVC = UserDetailRouter.createModule(with: username)
        sourceView.navigationController?.pushViewController(detailVC, animated: true)
        
        print("ROUTER: \(username) kullanıcısının detayına gitme komutu alındı.")
    }
}
