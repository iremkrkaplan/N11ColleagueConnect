//
//  UserFavoritesViewController.swift
//  N11PeopleProject
//
//  Created by irem karakaplan on 7.09.2025.
//

import UIKit

final class UserFavoritesViewController: BaseScrollViewController, UserFavoritesViewInput, ErrorViewDelegate {
    
    var output: UserFavoritesViewOutput?
    
    private var collectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var dataSource: UICollectionViewDiffableDataSource<Int, UserListCellModel>!
    private var emptyStateView: EmptyStateView = .build()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }
    
    override func addUI() {
        super.addUI()
        addSearchController()
        addCollectionView()
        addDataSource()
        addStateViews()
    }
    
    func bind(results: [UserListCellModel]) {
        errorView.isHidden = true
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        emptyStateView.isHidden = true
        scrollView.isHidden = false
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserListCellModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(results, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func displayEmptyState(_ model: EmptyStatePresentationModel) {
        scrollView.isHidden = true
        errorView.isHidden = true
        
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        
        emptyStateView.isHidden = false
        emptyStateView.bind(model)
    }
    
    func displayLoading() {
        scrollView.isHidden = true
        errorView.isHidden = true
        emptyStateView.isHidden = true
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func displayError(_ model: ErrorPresentationModel) {
        scrollView.isHidden = true
        emptyStateView.isHidden = true
        errorView.isHidden = false
        
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        
        errorView.bind(model)
    }
    
    func hideAllContent() {
        scrollView.isHidden = true
        errorView.isHidden = true
        emptyStateView.isHidden = true
        activityIndicator.stopAnimating()
        scrollView.refreshControl?.endRefreshing()
    }
    
    func errorViewDidTapRetryButton(_ errorView: ErrorView) {
        print("Delegate metodu ViewController'da tetiklendi. Presenter çağrılıyor.")
        output?.retryButtonTapped()
    }
}

private extension UserFavoritesViewController {
    func addStateViews() {
        errorView.delegate = self
        view.addSubview(errorView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        errorView.isHidden = true
        activityIndicator.isHidden = true
        emptyStateView.isHidden = true
    }
}

private extension UserFavoritesViewController {
    func addSearchController() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func addCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        
        view.addSubview(collectionView)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: layout.cellIdentifier)
    }
    
    func addDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, UserListCellModel>(collectionView: collectionView) {
            [weak self] (collectionView, indexPath, cellModel) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self?.layout.cellIdentifier ?? "", for: indexPath) as? UserCell else {
                fatalError("Cannot create UserCell")
            }
            
            cell.bind(with: cellModel)
            cell.onFavoriteButtonTapped = {
                self?.output?.favoriteButtonTapped(for: cellModel)
            }
            return cell
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(layout.itemWidthFractional), heightDimension: .estimated(layout.itemEstimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(layout.groupWidthFractional), heightDimension: .estimated(layout.groupEstimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(layout.interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = layout.interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: layout.contentInsets.top,
            leading: layout.contentInsets.leading,
            bottom: layout.contentInsets.bottom,
            trailing: layout.contentInsets.trailing
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension UserFavoritesViewController: UICollectionViewDelegate, UISearchBarDelegate {
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        output?.didPullToRefresh()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text ?? ""
        output?.searchButtonTapped(with: query)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        output?.searchButtonTapped(with: "")
        searchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellModel = dataSource.itemIdentifier(for: indexPath) else { return }
        output?.didSelectUser(with: cellModel)
    }
}

private extension UserFavoritesViewController {
    private struct Layout {
        let contentInsets: NSDirectionalEdgeInsets = .init(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        let itemWidthFractional: CGFloat = 0.5
        let itemEstimatedHeight: CGFloat = 180
        let groupWidthFractional: CGFloat = 1.0
        let groupEstimatedHeight: CGFloat = 180
        let groupItemCount: Int = 2
        let interItemSpacing: CGFloat = 16
        let interGroupSpacing: CGFloat = 16
        let cellIdentifier: String = "UserCell"
    }
}
