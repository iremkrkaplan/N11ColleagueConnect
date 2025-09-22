//
//  UserFavoritesContracts.swift
//  N11PeopleProject
//
//  Created by irem karakaplan on 7.09.2025.
//
import UIKit

protocol UserFavoritesViewInput: AnyObject {
    var output: UserFavoritesViewOutput? { get set }
    func displayLoading()
    func hideAllContent()
    func bind(results: [UserListCellModel])
    func displayEmptyState(_ emtptyStateModel: EmptyStatePresentationModel)
    func displayError(_ errorModel: ErrorPresentationModel)
}

protocol UserFavoritesViewOutput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectUser(with model: UserListCellModel)
    func favoriteButtonTapped(for model: UserListCellModel)
    func searchButtonTapped(with query: String)
    func didPullToRefresh()
    func retryButtonTapped()
}

protocol UserFavoritesPresenterInput: UserFavoritesViewOutput, UserFavoritesInteractorOutput {
    var view: UserFavoritesViewInput? { get set }
    var interactor: UserFavoritesInteractorInput? { get set }
    var router: UserFavoritesRouterInput? { get set }
}

protocol UserFavoritesInteractorInput: AnyObject {
    var output: UserFavoritesInteractorOutput? { get set }
//    func toggleFavoriteStatus(for username: String)
//    func removeFavorite(username: String)
    func toggleFavorite(for username: String)
    func fetchFavoritedUsers(with query: String?)
}

protocol UserFavoritesInteractorOutput: AnyObject {
    func didFetchFavoritesSuccessfully(users: [User])
    func didFailToFetchFavorites(error: Error)
    func favoriteStatusDidChange()
}

protocol UserFavoritesRouterInput: AnyObject {
    var viewController: UIViewController? { get set }
    func navigateToUserDetail(username: String)
}
