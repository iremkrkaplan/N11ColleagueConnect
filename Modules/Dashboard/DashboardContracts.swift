//
//  DashboardContracts.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 15.08.2025.
//
import UIKit
// MARK: - View Protocol
protocol DashboardViewInput: AnyObject {
    var presenter: DashboardViewOutput? { get set }
    func displayLoading()
    func bind(viewData: DashboardViewData)
    func displayError(_ errorModel: ErrorPresentationModel)
}

protocol DashboardViewOutput: AnyObject {
    func viewDidLoad()
    func didPullToRefresh()
    func settingsButtonTapped()
    func retryButtonTapped()
    func didTapLogoutButton()
    func didTapSearchButton()
    func didTapFavoritesButton()
}

// MARK: - Presenter Protocol
protocol DashboardPresenterInput: DashboardViewOutput, DashboardInteractorOutput {
    
    var view: DashboardViewInput? { get }
    var interactor: DashboardInteractorInput { get }
    var router: DashboardRouterInput { get }
    
}

// MARK: - Interactor Protocol
protocol DashboardInteractorInput: AnyObject {
    var  presenter: DashboardInteractorOutput? { get set }
    func fetchAuthenticatedUser()
}

protocol DashboardInteractorOutput: AnyObject {
    func didFetchUser(user: User)
    func didFailToFetchUser(error: Error)
}

// MARK: - Router
protocol DashboardRouterInput: AnyObject {
    var viewController: UIViewController? { get set }
    func logout()
    func navigateToSearch()
    func navigateToFavorites()
}

protocol DashboardRouterDelegate: AnyObject {
    func logout()
}
