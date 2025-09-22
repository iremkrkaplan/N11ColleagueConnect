//
//  UserFavoritesInteractor.swift
//  N11PeopleProject
//
//  Created by irem karakaplan on 7.09.2025.
//
import Foundation

final class UserFavoritesInteractor: UserFavoritesInteractorInput {

    weak var output: UserFavoritesInteractorOutput?
    private let apiClient: APIClient
    private let favoriteService: FavoriteStorageServiceProtocol
    
    init(apiClient: APIClient,
         favoriteService: FavoriteStorageServiceProtocol = FavoriteStorageService.shared) {
        self.apiClient = apiClient
        self.favoriteService = favoriteService
    }

    func fetchFavoritedUsers(with query: String? = nil) {
        let favoriteUsernames = favoriteService.getFavorites()
        
        if favoriteUsernames.isEmpty {
            Task { await MainActor.run { output?.didFetchFavoritesSuccessfully(users: []) } }
            return
        }
        
        Task {
            do {
                let userDetails: [UserDetail] = try await withThrowingTaskGroup(of: UserDetail.self) { group in
                    
                    for username in favoriteUsernames {
                        group.addTask {
                            let params = GetUserDetailParams(username: username)
                            return try await self.apiClient.getUserDetail(params)
                        }
                    }
                    
                    var collectedDetails: [UserDetail] = []
                    for try await detail in group {
                        collectedDetails.append(detail)
                    }
                    return collectedDetails
                }
                
                var users = userDetails.map { detail -> User in
                    return User(
                        login: detail.login,
                        id: detail.id,
                        avatarUrl: detail.avatarUrl,
                        name: detail.name
                    )
                }
                
                if let searchQuery = query?.lowercased(), !searchQuery.isEmpty {
                    users = users.filter { user in
                        let nameMatch = user.name?.lowercased().contains(searchQuery) ?? false
                        let loginMatch = user.login.lowercased().contains(searchQuery)
                        return nameMatch || loginMatch
                    }
                }
                
                await MainActor.run {
                    output?.didFetchFavoritesSuccessfully(users: users)
                }
                
            } catch {
                await MainActor.run {
                    output?.didFailToFetchFavorites(error: error)
                }
            }
        }
    }
    
    func toggleFavorite(for username: String) {
        favoriteService.toggleFavorite(username: username)
        Task { await MainActor.run { output?.favoriteStatusDidChange() } }
    }
}
