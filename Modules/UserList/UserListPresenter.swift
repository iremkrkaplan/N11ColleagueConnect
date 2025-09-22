//
//  UserListPresenter.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 28.08.2025.
//

import Foundation

final class UserListPresenter: UserListViewOutput, UserListInteractorOutput {
    
    private weak var view: UserListViewInput?
    private let interactor: UserListInteractorInput
    private let router: UserListRouterInput
    private var users: [User] = []
    private var currentSearchQuery: String = ""
    private let favoriteService: FavoriteStorageServiceProtocol
    
    init(view: UserListViewInput,
         interactor: UserListInteractorInput,
         router: UserListRouterInput,
         favoriteService: FavoriteStorageServiceProtocol = FavoriteStorageService.shared) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
        self.favoriteService = favoriteService
    }
    
    func viewDidLoad() {
        let initialData = UserListViewData(
            title: "Kullanıcı Ara",
            searchPlaceholder: "GitHub kullanıcısı ara..."
        )
        view?.displayInitialState(with: initialData)
        
        view?.displayEmptyState(.searchEmptyState)
    }
    
    func searchButtonTapped(with query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        self.currentSearchQuery = trimmedQuery
        
        guard !trimmedQuery.isEmpty else {
            view?.displayEmptyState(.searchEmptyState)
            return
        }
        
        view?.displayLoading(true)
        interactor.searchUsers(with: trimmedQuery)
    }
    
    func favoriteButtonTapped(for model: UserListCellModel) {
        interactor.toggleFavorite(for: model.username)
    }
    
    func didSelectUser(with model: UserListCellModel) {
        router.navigateToUserDetail(username: model.username)
    }
    
    
    func didFetchUsersSuccessfully(users: [User]) {
        self.users = users
        let cellModels = mapUsersToCellModels(from: users)
        
        view?.displayLoading(false)
        
        if cellModels.isEmpty {
            let emptyStateModel = EmptyStatePresentationModel(
                titleViewText: "Sonuç Bulunamadı",
                subtitleViewText: "Girdiğiniz kritere uygun kullanıcı bulunamadı.",
                imageName: "EmptySearch"
            )
            view?.displayEmptyState(emptyStateModel)
        } else {
            view?.bind(results: cellModels)
        }
    }
    
    func didFailToFetchUsers(error: Error) {
        view?.displayLoading(false)
        view?.displayError(title: "Hata Oluştu", message: "Arama sırasında bir sorun oluştu. Lütfen tekrar deneyin.")
        print("Error from Interactor: \(error.localizedDescription)")
    }
    
    func favoriteStatusDidChange() {
        let updatedCellModels = mapUsersToCellModels(from: self.users)
        view?.bind(results: updatedCellModels)
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
