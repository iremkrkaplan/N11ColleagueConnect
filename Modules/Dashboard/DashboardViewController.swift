//
//  DashboardViewController.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 8.08.2025.
//

import UIKit

final class DashboardViewController: BaseScrollViewController, DashboardViewInput, ErrorViewDelegate{
    var presenter: DashboardViewOutput?
    private lazy var profileView: ProfileView = .build()
    private lazy var galleryView: GalleryView = .build()
    private lazy var titleView: UILabel = .build()
    private lazy var subtitleView: UILabel = .build()
    private lazy var settingsActionView: UIButton = .build()
    private lazy var errorView: ErrorView = .build()
    private lazy var settingsButton: UIButton = .build()
    private lazy var galleryTitleLabel: UILabel = .build()
    private lazy var quickActionsStackView: UIStackView = .build()
    private let refreshControl = UIRefreshControl()
    private let layout: Layout = .init()
    
    private lazy var activityIndicator: UIActivityIndicatorView = .build {
        $0.style = .large
        $0.color = .systemPurple
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupRefreshControl()
        presenter?.viewDidLoad()
    }
    
    override func addUI() {
        super.addUI()
        addNavigationBar()
        addProfile()
        addTitle()
        addSubtitle()
        addQuickActions()
        addGalleryTitle()
        addGalleryView()
        addSettingsAction()
        addStateViews()
    }
    
    func bind(viewData: DashboardViewData) {
        scrollView.isHidden = false
        errorView.isHidden = true
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        
        titleView.text = viewData.titleViewText
        subtitleView.text = viewData.subtitleViewText
        galleryTitleLabel.text = viewData.galleryTitleLabelText
        
        profileView.bind(viewData.profileModel)
        configureQuickActions(with: viewData.quickActionModels)
        configureSettingsAction(with: viewData.settingsButtonModel)
        configureGallery(with: viewData.galleryModel)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc private func logoutTapped() {
        presenter?.didTapLogoutButton()
    }
    
    func displayLoading() {
        scrollView.isHidden = true
        errorView.isHidden = true
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func displayError(_ model: ErrorPresentationModel) {
        scrollView.isHidden = true
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        
        errorView.isHidden = false
        errorView.bind(model)
    }
    
    private func hideAllContent() {
        scrollView.isHidden = true
        errorView.isHidden = true
        activityIndicator.stopAnimating()
        scrollView.refreshControl?.endRefreshing()
    }
    
    func errorViewDidTapRetryButton(_ errorView: ErrorView) {
        print("Delegate metodu ViewController'da tetiklendi. Presenter çağrılıyor.")
        presenter?.retryButtonTapped()
    }
}

private extension DashboardViewController {
    func addStateViews() {
        errorView.delegate = self
        view.addSubview(errorView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

private extension DashboardViewController {
    
    private func addNavigationBar() {
        navigationItem.title = "Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func addProfile() {
        contentView.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.contentInsets.top),
            profileView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func addSettingsAction() {
        contentView.addSubview(settingsButton)
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: profileView.topAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.contentInsets.trailing),
            settingsButton.widthAnchor.constraint(equalToConstant: layout.settingsActionSize.width),
            settingsButton.heightAnchor.constraint(equalToConstant: layout.settingsActionSize.height)
        ])
    }
    
    private func addTitle() {
        titleView.font = .systemFont(ofSize: layout.titleFontSize, weight: .bold)
        titleView.textAlignment = .center
        titleView.textColor = .systemPurple
        titleView.setContentHuggingPriority(.required, for: .vertical)
        titleView.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: layout.profileBottomSpacing),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.contentInsets.leading),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.contentInsets.trailing),
        ])
    }
    
    private func addSubtitle() {
        subtitleView.font = .systemFont(ofSize: layout.subtitleFontSize, weight: .regular)
        subtitleView.textColor = .gray
        subtitleView.textAlignment = .center
        contentView.addSubview(subtitleView)
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            subtitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subtitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func addQuickActions() {
        quickActionsStackView.axis = .vertical
        quickActionsStackView.spacing = layout.quickActionRowSpacing
        quickActionsStackView.alignment = .center
        
        contentView.addSubview(quickActionsStackView)
        NSLayoutConstraint.activate([
            quickActionsStackView.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: layout.quickActionsTopSpacing),
            quickActionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.contentInsets.leading),
            quickActionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.contentInsets.trailing)
        ])
    }
    
    private func addGalleryTitle() {
        galleryTitleLabel.font = .systemFont(ofSize: layout.galleryTitleFontSize, weight: .bold)
        galleryTitleLabel.textColor = .black
        contentView.addSubview(galleryTitleLabel)
        NSLayoutConstraint.activate([
            galleryTitleLabel.topAnchor.constraint(equalTo: quickActionsStackView.bottomAnchor, constant: layout.gallerySectionTopSpacing),
            galleryTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.galleryHorizontalPadding),
            galleryTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.galleryHorizontalPadding)
        ])
    }
    
    private func addGalleryView() {
        contentView.addSubview(galleryView)
        NSLayoutConstraint.activate([
            galleryView.topAnchor.constraint(equalTo: galleryTitleLabel.bottomAnchor, constant: layout.galleryTitleBottomSpacing),
            galleryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.galleryHorizontalPadding),
            galleryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.galleryHorizontalPadding),
            galleryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -layout.galleryBottomPadding)
        ])
    }
    
    private func configureSettingsAction(with model: SimpleActionPresentationModel) {
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .systemPurple
        config.background.cornerRadius = layout.settingsActionSize.width / 2
        config.image = .init(systemName: model.iconName)
        settingsButton.configuration = config
        
        settingsButton.addAction(UIAction { _ in model.action() }, for: .touchUpInside)
    }
    
    private func configureQuickActions(with models: [[QuickActionButtonPresentationModel]]) {
        quickActionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        models.forEach { rowModels in
            let rowStackView = UIStackView()
            rowStackView.spacing = layout.quickActionRowSpacing
            rowStackView.distribution = .fillEqually
            
            rowModels.forEach { model in
                let button = QuickActionButton()
                button.bind(with: model)
                rowStackView.addArrangedSubview(button)
            }
            quickActionsStackView.addArrangedSubview(rowStackView)
        }
    }
    
    private func configureGallery(with model: GalleryPresentationModel?) {
        guard let model = model else {
            galleryView.isHidden = true
            return
        }
        
        galleryView.isHidden = false
        galleryView.bind(with: model)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    
    @objc private func didPullToRefresh() {
        presenter?.didPullToRefresh()
    }
    
}

extension DashboardViewController {
    private struct Layout {
        let contentInsets: NSDirectionalEdgeInsets = .init(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        
        let settingsActionSize: CGSize = .init(width: 40, height: 40)
        
        let profileBottomSpacing: CGFloat = 24
        let quickActionsTopSpacing: CGFloat = 30
        let quickActionRowSpacing: CGFloat = 20
        let gallerySectionTopSpacing: CGFloat = 40
        let galleryTitleBottomSpacing: CGFloat = 16
        
        let galleryHorizontalPadding: CGFloat = 20
        let galleryBottomPadding: CGFloat = 20
        
        let titleFontSize: CGFloat = 34
        let subtitleFontSize: CGFloat = 17
        let galleryTitleFontSize: CGFloat = 26
    }
}

@available(iOS 17, *)
#Preview("Success State") {
    let view = DashboardViewController()
    let interactor = DashboardMockInteractor(scenario: .success(DashboardMockInteractor.mockUser))
    let router = DashboardRouter()
    let presenter = DashboardPresenter(view: view,
                                       interactor: interactor,
                                       router: router)
    view.presenter = presenter
    interactor.presenter = presenter
    
    return UINavigationController(rootViewController: view)
}

@available(iOS 17, *)
#Preview("Error State") {
    
    let interactor = DashboardMockInteractor(scenario: .failure(PreviewError.forcedFailure))
    let router = DashboardRouter()
    let view = DashboardViewController()
    let presenter = DashboardPresenter(view: view, interactor: interactor, router: router)
    view.presenter = presenter
    interactor.presenter = presenter
    
    return UINavigationController(rootViewController: view)
}