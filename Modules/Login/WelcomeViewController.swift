//
//  WelcomeViewController.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 11.09.2025.
//

import UIKit
import Kingfisher

protocol WelcomeViewDelegate: AnyObject {
    func didTapLoginButton()
}

final class WelcomeViewController: BaseViewController {
    
    // MARK: - Properties
    
    private struct Layout {
        let imageSize: CGSize = .init(width: 150, height: 150)
        let imageBottomOffsetFromCenter: CGFloat = 80
        
        let titleTopPadding: CGFloat = 32
        let buttonTopPadding: CGFloat = 40
        
        let horizontalPadding: CGFloat = 32
        let buttonHeight: CGFloat = 50
    }
    
    private let layout: Layout = .init()
    
    private lazy var imageView: UIImageView = .build()
    private lazy var titleLabel: UILabel = .build()
    private lazy var loginButton: UIButton = .build()

    weak var delegate: WelcomeViewDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(with: .defaultWelcome)
    }

    override func addUI() {
        super.addUI()
        addImageView()
        addTitleLabel()
        addLoginButton()
    }
    
    func bind(with model: WelcomePresentationModel) {
        if let imageName = model.imageName {
            if let sfSymbolImage = UIImage(systemName: imageName) {
                imageView.image = sfSymbolImage
            } else {
                imageView.image = UIImage(named: imageName)
            }
        } else {
            imageView.image = nil
        }
        
        titleLabel.text = model.titleViewText
        loginButton.setTitle(model.loginButtonTitle, for: .normal)
    }
    
    @objc private func loginButtonTapped() {
        delegate?.didTapLoginButton()
    }
}

// MARK: - Private Extension

private extension WelcomeViewController {
    
    func addImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemPurple
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -layout.imageBottomOffsetFromCenter),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: layout.imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: layout.imageSize.height)
        ])
    }
    
    func addTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 30, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemPurple
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: layout.titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.horizontalPadding)
        ])
    }
    
    func addLoginButton() {
        loginButton.backgroundColor = .systemPurple
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: layout.buttonHeight),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.horizontalPadding),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.horizontalPadding),
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: layout.buttonTopPadding)
        ])
    }
}
