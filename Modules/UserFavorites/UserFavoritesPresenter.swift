//
//  UserFavoritesPresenter.swift
//  N11PeopleProject
//
//  Created by irem karakaplan on 7.09.2025.
//
import Foundation

final class UserFavoritesPresenter: UserFavoritesPresenterInput {

    weak var view: UserFavoritesViewInput?
    var interactor: UserFavoritesInteractorInput?
    var router: UserFavoritesRouterInput?
    private var allFavoritedUsers: [User] = []
    private var currentSearchQuery: String = ""
    private let favoriteService: FavoriteStorageServiceProtocol
    
    init(view: UserFavoritesViewInput,
         interactor: UserFavoritesInteractorInput,
         router: UserFavoritesRouterInput,
         favoriteService: FavoriteStorageServiceProtocol = FavoriteStorageService.shared) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.favoriteService = favoriteService
    }
        
    func viewDidLoad() {
        view?.displayLoading()
        interactor?.fetchFavoritedUsers(with: nil)
    }
    
    func viewWillAppear() {
        view?.displayLoading()
        interactor?.fetchFavoritedUsers(with: currentSearchQuery.isEmpty ? nil : currentSearchQuery)
    }
    
    func searchButtonTapped(with query: String) {
        self.currentSearchQuery = query.trimmingCharacters(in: .whitespaces)
        
        view?.displayLoading()
        interactor?.fetchFavoritedUsers(with: currentSearchQuery.isEmpty ? nil : currentSearchQuery)
    }
    
    func retryButtonTapped() {
        print("Presenter, ViewController'dan gelen retry isteğini aldı.")
        viewDidLoad()
    }
    
    func didSelectUser(with model: UserListCellModel) {
        router?.navigateToUserDetail(username: model.username)
    }
    
    func favoriteButtonTapped(for model: UserListCellModel) {
        interactor?.toggleFavorite(for: model.username)
    }

    func didFetchFavoritesSuccessfully(users: [User]) {
        let cellModels = mapUsersToCellModels(from: users)

        if cellModels.isEmpty {
            let emptyStateModel: EmptyStatePresentationModel
            if currentSearchQuery.isEmpty {
                emptyStateModel = .emptyState
            } else {
                emptyStateModel = EmptyStatePresentationModel(
                    titleViewText: "Arama Sonucu Yok",
                    subtitleViewText: "'\(currentSearchQuery)' ile eşleşen favori kullanıcı bulunamadı.",
                    imageName: "EmptySearch"
                )
            }
            view?.displayEmptyState(emptyStateModel)
        } else {
            view?.bind(results: cellModels)
        }
    }

    func didFailToFetchFavorites(error: Error) {
        print("Presenter'a hata ulaştı: \(error.localizedDescription)")
        
        let errorModel = ErrorPresentationModel.networkConnectionError
        
        view?.displayError(errorModel)
    }
    
    func favoriteStatusDidChange() {
        interactor?.fetchFavoritedUsers(with: currentSearchQuery.isEmpty ? nil : currentSearchQuery)
    }
    
    func didPullToRefresh() {
        self.currentSearchQuery = ""
        view?.displayLoading()
        interactor?.fetchFavoritedUsers(with: nil)
    }

    private func mapUsersToCellModels(from users: [User]) -> [UserListCellModel] {
        return users.map { user in
            UserListCellModel(
                id: user.id,
                username: user.login,
                avatarURL: URL(string: user.avatarUrl),
                isFavorite: favoriteService.isFavorite(username: user.login)
            )
        }
    }
}
