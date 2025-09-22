//
//  DashboardPresenter.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 25.08.2025.
//

import Foundation

final class DashboardPresenter: DashboardPresenterInput {

    private(set) weak var view: DashboardViewInput?
    private(set) var interactor: DashboardInteractorInput
    private(set) var router: DashboardRouterInput

    init(view: DashboardViewInput,
         interactor: DashboardInteractorInput,
         router: DashboardRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension DashboardPresenter: DashboardInteractorOutput {
    func didFetchUser(user: User) {
        let viewData = createViewData(from: user)
        view?.bind(viewData: viewData)
    }
    
    func didFailToFetchUser(error: Error) {
        print("Presenter'a hata ulaştı: \(error.localizedDescription)")
        
        let errorModel = ErrorPresentationModel.networkConnectionError
        
        view?.displayError(errorModel)
    }
}

extension DashboardPresenter {
    func viewDidLoad() {
        view?.displayLoading()
        interactor.fetchAuthenticatedUser()
    }

    func didPullToRefresh() {
        interactor.fetchAuthenticatedUser()
    }
    
    func didTapSearchButton() {
        print("Kayıt Sorgulama butonu tıklandı.")
        // Router'a kullanıcı arama sayfasına gitmesi için talimat ver.
        router.navigateToSearch()
    }
    
    func didTapFavoritesButton() {
        print("Favorilerim butonu tıklandı.")
        // Router'a favoriler sayfasına gitmesi için talimat ver.
        router.navigateToFavorites()
    }
    
    func settingsButtonTapped() {
        print("Ayarlar butonu tıklandı! Bu istek Presenter'a geldi.")
    }
    
    func retryButtonTapped() {
        print("Presenter, ViewController'dan gelen retry isteğini aldı.")
        viewDidLoad()
    }
}

private extension DashboardPresenter {
    
    func createViewData(from user: User) -> DashboardViewData {
        return .init(
            titleViewText: "Yönetim Paneli",
            subtitleViewText: "n11 Kültür",
            galleryTitleLabelText: "n11 Galeri",
            profileModel: .init(
                avatarModel: .init(
                    url: user.AvatarAsURL,
                    placeholderImageName: "PlaceHolder",
                    shape: .circle
                ),
                userNameText: user.login,
                nameText: user.name
            ),
            quickActionModels: createPlaceholderQuickActionModels(),
            settingsButtonModel: createPlaceholderSettingsButtonModel(),
            galleryModel: createPlaceholderGalleryModel()
        )
    }
    
    func createPlaceholderSettingsButtonModel() -> SimpleActionPresentationModel {
        return .init(
            iconName: "gearshape.fill",
            action: {
                self.settingsButtonTapped()
                // TODO: `self?.presenter.navigateToSettings()` olacak.
            }
        )
    }
    
    func createPlaceholderQuickActionModels() -> [[QuickActionButtonPresentationModel]] {
        return [
            [
                .init(
                    title: "Kayıt Sorgulama",
                    iconName: "magnifyingglass",
                    color: .systemPink
                ) {
                    print("Kayıt Sorgulama tıklandı")
                    self.didTapSearchButton()
                },
                .init(
                    title: "Favorilediklerim",
                    iconName: "heart.fill",
                    color: .systemPurple
                ) {
                    print("Favorilediklerim tıklandı")
                    self.didTapFavoritesButton()
                },
                .init(
                    title: "Görüntülediklerim",
                    iconName: "eye.fill",
                    color: .systemPink
                ) {
                    print("Görüntülediklerim tıklandı")
                }
            ],
            [
                .init(
                    title: "Arkadaşlarım",
                    iconName: "person.badge.plus",
                    color: .systemPurple
                ) {
                    print("Arkadaşlarım tıklandı")
                },
                .init(
                    title: "Bu Ay Doğanlar",
                    iconName: "gift.fill",
                    color: .systemPink
                ) {
                    print("Bu Ay Doğanlar tıklandı")
                }
            ]
        ]
    }
    
    func createPlaceholderGalleryModel() -> GalleryPresentationModel {
        let placeholderItemCount = 6
        let placeholderItem = GalleryItemPresentationModel(
            imageSystemName: "ladybug.fill",
            tintColor: .systemGray4
        )
        let allItems = Array<GalleryItemPresentationModel>(repeating: placeholderItem, count: placeholderItemCount)
        return GalleryPresentationModel(items: allItems)
    }
}

extension DashboardPresenter{
    func didTapLogoutButton() {
        router.logout()
    }
}
