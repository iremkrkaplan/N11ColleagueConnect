//
//  UserDetailViewController.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 3.09.2025.
//

import UIKit
final class UserDetailViewController: BaseScrollViewController, UserDetailViewInput, ErrorViewDelegate {
    
    var output: UserDetailViewOutput?
//    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var profileView: ProfileView = .build()
    private lazy var bioLabel: UILabel = .build ()
    private lazy var statsStackView: UIStackView = .build()
    private lazy var memberSinceLabel: UILabel = .build()
    private lazy var githubButton: UIButton = .build()
    private lazy var favoriteButton: UIBarButtonItem = .init()
    private lazy var errorView: ErrorView = .build()
    private let refreshControl = UIRefreshControl()
    private let layout: Layout = .init()

    private lazy var activityIndicator: UIActivityIndicatorView = .build {
        $0.style = .large
        $0.color = .systemPurple
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        output?.viewDidLoad()
    }
    
    override func addUI() {
        super.addUI()
        addActivityIndicator()
        addProfileView()
        addBioLabel()
        addStatsStackView()
        addMemberSinceLabel()
        addGitHubButton()
        addFavoriteButtonToNavBar()
        addStateViews()
    }
    
    func bind(viewData: UserDetailViewData) {
        scrollView.isHidden = false
        errorView.isHidden = true
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        
        profileView.bind(viewData.profileModel)
        
        if let bio = viewData.bioText, !bio.isEmpty {
              bioLabel.text = bio
              bioLabel.isHidden = false
          } else {
              bioLabel.isHidden = true
          }
        
          configureStatsStackView(with: viewData.statsModel)
          
         memberSinceLabel.text = viewData.memberSinceText
          
          configureGitHubButton(with: viewData.githubButtonModel)
          
          let favoriteIconName = viewData.isFavorite ? "heart.fill" : "heart"
          favoriteButton.image = UIImage(systemName: favoriteIconName)
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
        output?.retryButtonTapped()
    }
}

private extension UserDetailViewController {
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

private extension UserDetailViewController{
    
    func addActivityIndicator() {
        activityIndicator.color = .systemPurple
        view.addSubview(activityIndicator)
    }
    
    func addProfileView() {
        contentView.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.topPadding),
            profileView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.horizontalPadding),
            profileView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.horizontalPadding),
        ])
    }
    
    func addBioLabel() {
        bioLabel.font = .systemFont(ofSize: 15)
        bioLabel.textColor = .label
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
        contentView.addSubview(bioLabel)
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: layout.standardSpacing),
            bioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.horizontalPadding),
            bioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.horizontalPadding),
        ])
    }
    
    func addStatsStackView() {
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 8
        contentView.addSubview(statsStackView)
        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: layout.largeSpacing),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.horizontalPadding),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.horizontalPadding),
        ])
    }
    
    func addMemberSinceLabel() {
        memberSinceLabel.font = .systemFont(ofSize: 12)
        memberSinceLabel.textColor = .secondaryLabel
        memberSinceLabel.textAlignment = .center
        contentView.addSubview(memberSinceLabel)
        NSLayoutConstraint.activate([
            memberSinceLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: layout.largeSpacing),
            memberSinceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.horizontalPadding),
            memberSinceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.horizontalPadding),
        ])
    }
    
    func addGitHubButton() {
        contentView.addSubview(githubButton)
        NSLayoutConstraint.activate([
            githubButton.topAnchor.constraint(equalTo: memberSinceLabel.bottomAnchor, constant: layout.xlargeSpacing),
            githubButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            githubButton.heightAnchor.constraint(equalToConstant: 50),
            githubButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            githubButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -layout.bottomPadding)
        ])
    }

    func addFavoriteButtonToNavBar() {
        favoriteButton.primaryAction = UIAction(handler: { [weak self] _ in
            self?.output?.favoriteButtonTapped()
        })
        favoriteButton.tintColor = .systemPink
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func configureStatsStackView(with model: UserStatsPresentationModel) {
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let followersStat = createStatView(value: model.followersText, label: "Takipçi")
        let followingStat = createStatView(value: model.followingText, label: "Takip")
        statsStackView.addArrangedSubview(followersStat)
        statsStackView.addArrangedSubview(followingStat)
    }

    func configureGitHubButton(with model: GitHubButtonPresentationModel) {
        var config = UIButton.Configuration.filled()
        config.title = model.title
        config.image = UIImage(systemName: "arrow.up.right.square")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.cornerStyle = .capsule
        githubButton.configuration = config
        githubButton.addAction(UIAction { _ in model.action() }, for: .touchUpInside)
        // `primaryAction` kullanmak, `addAction`'tan daha modern ve nettir,
        // çünkü bir butonun genellikle tek bir ana eylemi vardır.
//        githubButton.primaryAction = UIAction { _ in model.action() }
    }
    
    func createStatView(value: String, label: String) -> UIView {
        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 17, weight: .bold)
        valueLabel.text = value
        
        let textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 13)
        textLabel.textColor = .secondaryLabel
        textLabel.text = label
        
        let stackView = UIStackView(arrangedSubviews: [valueLabel, textLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    @objc private func didPullToRefresh() {
        output?.didPullToRefresh()
    }
}

extension UserDetailViewController {
    private struct Layout {
      /*  let contentInsets: NSDirectionalEdgeInsets = .init(
            top: 24,
            leading: 16,
            bottom: 16,
            trailing: 16
        ) */
        let topPadding: CGFloat = 24
        let bottomPadding: CGFloat = 40
        let horizontalPadding: CGFloat = 24
        let standardSpacing: CGFloat = 16
        let largeSpacing: CGFloat = 24
        let xlargeSpacing: CGFloat = 32
    }
}
