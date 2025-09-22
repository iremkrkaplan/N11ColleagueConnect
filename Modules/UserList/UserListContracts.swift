//
//  UserListContracts.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 28.08.2025.
//

import UIKit

protocol UserListViewInput: AnyObject {
    var output: UserListViewOutput? { get set }
    func displayInitialState(with data: UserListViewData)
    func displayLoading(_ isLoading: Bool)
    func bind(results: [UserListCellModel])
    func displayError(title: String, message: String)
    func displayEmptyState(_ emtptyStateModel: EmptyStatePresentationModel)
}

protocol UserListViewOutput: AnyObject {
    func viewDidLoad()
    func searchButtonTapped(with query: String)
    func didSelectUser(with model: UserListCellModel)
    func favoriteButtonTapped(for model: UserListCellModel)
}

protocol UserListPresenterInput: UserListViewOutput, UserListInteractorOutput {
    var view: UserListViewInput? { get set }
    var interactor: UserListInteractorInput? { get set }
    var router: UserListRouterInput? { get set }
}

protocol UserListInteractorInput: AnyObject {
    var output: UserListInteractorOutput? { get set }
    func searchUsers(with query: String)
    func toggleFavorite(for username: String)
}

protocol UserListInteractorOutput: AnyObject {
    func didFetchUsersSuccessfully(users: [User])
    func didFailToFetchUsers(error: Error)
    func favoriteStatusDidChange()
}

protocol UserListRouterInput: AnyObject {
    var viewController: UIViewController? { get set }
    func navigateToUserDetail(username: String)
}
