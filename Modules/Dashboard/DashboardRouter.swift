//
//  DashboardRouter.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 27.08.2025.
//
import UIKit

final class DashboardRouter: DashboardRouterInput {
    
    weak var viewController: UIViewController?
    weak var delegate: DashboardRouterDelegate?
    
    func navigateToSearch() {
        // Kullanıcı Arama sayfasını oluştur ve push et
        let searchVC = UserListRouter.createModule()
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func navigateToFavorites() {
        // Favoriler sayfasını oluştur ve push et
        let favoritesVC = UserFavoritesRouter.createModule()
        viewController?.navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    func logout() {
        delegate?.logout()
    }
    
    static func createModule(delegate: DashboardRouterDelegate) -> UIViewController {
        let view = DashboardViewController()
        let interactor: DashboardInteractorInput = DashboardAPIInteractor(apiClient: .live)
        let router: DashboardRouterInput & DashboardRouter = DashboardRouter()
        
        let presenter: DashboardPresenterInput & DashboardInteractorOutput = DashboardPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        (router as? DashboardRouter)?.delegate = delegate
        
        return view
    }
}
