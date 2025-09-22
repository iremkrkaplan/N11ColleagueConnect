//
//  LoginViewController.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 10.09.2025.
//

import UIKit
import WebKit

final class LoginViewController: BaseViewController, LoginViewInput, WKNavigationDelegate {
    
    var output: LoginViewOutput?
    private let webView: WKWebView = .build()
    private var currentViewData: LoginViewData?
    
    private lazy var activityIndicator: UIActivityIndicatorView = .build {
        $0.style = .large
        $0.color = .systemPurple
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        output?.viewDidLoad()
    }
    
    override func addUI() {
        super.addUI()
        addWebView()
        addStateViews()
    }
    
    func bind(viewData: LoginViewData) {
        self.currentViewData = viewData
    }
    
    func load(url: URL) {
        webView.load(URLRequest(url: url))
        showWebView()
    }
    
    func displayLoading() {
        webView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showWebView() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        webView.isHidden = false
        view.bringSubviewToFront(webView)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let currentViewData = currentViewData else {
            decisionHandler(.allow)
            return
        }
        
        if let url = navigationAction.request.url,
           url.scheme == currentViewData.customURLScheme,
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let code = components.queryItems?.first(where: { $0.name == currentViewData.codeQueryItemName })?.value {

            output?.didCapture(code: code)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}

private extension LoginViewController {
    
    func addWebView() {
        webView.isHidden = false
        contentView.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func addStateViews() {
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

/*
import UIKit
import WebKit

final class LoginViewController: BaseViewController, LoginViewInput, WKNavigationDelegate {
    
    var output: LoginViewOutput?
    private let webView = WKWebView()
    private lazy var titleView: UILabel = .build()
    private lazy var loginButton: UIButton = .build()
    private let layout: Layout = .init()
    
    private var currentViewData: LoginViewData?
    
    private lazy var activityIndicator: UIActivityIndicatorView = .build {
        $0.style = .large
        $0.color = .systemPurple
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        output?.viewDidLoad()
    }
    
    override func addUI() {
        super.addUI()
        addTitle()
        addStateViews()
        addLoginButton()
        addWebView()
    }
    
    func bind(viewData: LoginViewData) {
        self.currentViewData = viewData
        self.titleView.text = viewData.infoTitleText
        self.loginButton.setTitle(viewData.loginButtonModel.title, for: .normal)
    }
    
    func load(url: URL) {
        self.currentViewData = LoginViewData(
            githubLoginURL: url,
            customURLScheme: "n11peopleproject",
            codeQueryItemName: "code",
            loginButtonModel: NavigateToGitHubButtonPresentationModel(
                title: "Giriş Yap",
                url: url,
                action: { }
            ),
            infoTitleText: "GitHub hesabınızla giriş yaparak devam edin"
        )

        webView.load(URLRequest(url: url))
        showWebView()
    }
    
    func displayLoading() {
        contentView.isHidden = true
        webView.isHidden = true
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    // WebView'ı göster
    private func showWebView() {
        contentView.isHidden = true
        activityIndicator.stopAnimating()
        
        webView.isHidden = false
        view.bringSubviewToFront(webView)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let currentViewData = currentViewData else {
            decisionHandler(.allow)
            return
        }
        
        if let url = navigationAction.request.url,
           url.scheme == currentViewData.customURLScheme,
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let code = components.queryItems?.first(where: { $0.name == currentViewData.codeQueryItemName })?.value {
            
            output?.didCapture(code: code)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    @objc private func loginButtonTapped() {
        guard let viewData = currentViewData else { return }
        viewData.loginButtonModel.action()
    }
}

private extension LoginViewController {
    
    func addWebView() {
        webView.isHidden = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
            titleView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: layout.contentInsets.top),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.contentInsets.leading),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.contentInsets.trailing)
        ])
    }
    
    private func addLoginButton() {
        loginButton.backgroundColor = .systemPurple
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.contentInsets.leading),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.contentInsets.trailing),
            loginButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -layout.contentInsets.bottom)
        ])
    }
    
    func configureLoginButton(with model: GitHubButtonPresentationModel) {
        var config = UIButton.Configuration.filled()
        config.title = model.title
        config.image = UIImage(systemName: "arrow.up.right.square")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.cornerStyle = .capsule
        loginButton.configuration = config
        loginButton.addAction(UIAction { _ in model.action() }, for: .touchUpInside)
    }

}

private extension LoginViewController {
    func addStateViews() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension LoginViewController {
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

*/







/*
import UIKit
import WebKit

final class LoginViewController: BaseViewController, LoginViewInput, WKNavigationDelegate, ErrorViewDelegate {
    
    var output: LoginViewOutput?
    private let webView = WKWebView()
    private lazy var errorView: ErrorView = .build()
    private lazy var titleView: UILabel = .build()
    private lazy var loginButton: UIButton = .build()
    private let layout: Layout = .init()
    
    private lazy var activityIndicator: UIActivityIndicatorView = .build {
        $0.style = .large
        $0.color = .systemPurple
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        output?.viewDidLoad()
    }
    
    override func addUI() {
        super.addUI()
        addTitle()
        addStateViews()
        addloginButton()
    }
    
    func bind(viewData: LoginViewData) {
        self.titleView.text = viewData.infoTitleText
        
        self.loginButton.setTitle(viewData.loginButtonModel.title, for: .normal)
    }
    
    
    func load(url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func displayLoading() {
        contentView.isHidden = true
        errorView.isHidden = true
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func displayError(_ model: ErrorPresentationModel) {
        contentView.isHidden = true
        activityIndicator.stopAnimating()
        
        errorView.isHidden = false
        errorView.bind(model)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
        if let url = navigationAction.request.url,
           url.scheme == viewData.customURLScheme,
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let code = components.queryItems?.first(where: { $0.name == viewData.codeQueryItemName })?.value {
            
            output?.didCapture(code: code)
            
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    private func setupUI() {
        title = "GitHub ile Giriş Yap"
        webView.navigationDelegate = self
        view = webView
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        guard let viewData = currentViewData else { return }
        viewData.loginButtonModel.action() // Presenter'daki action'ı çağır
    }
    
    func errorViewDidTapRetryButton(_ errorView: ErrorView) {
        print("Delegate metodu ViewController'da tetiklendi. Presenter çağrılıyor.")
        output?.retryButtonTapped()
    }
}
private extension LoginViewController{
    private func addTitle() {
        titleView.font = .systemFont(ofSize: layout.titleFontSize, weight: .bold)
        titleView.textAlignment = .center
        titleView.textColor = .systemPurple
        titleView.setContentHuggingPriority(.required, for: .vertical)
        titleView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(titleView)
        NSLayoutConstraint.activate([
            // infoTitleLabel - ContentView'in üstüne
            titleView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: layout.contentInsets.top),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.contentInsets.leading),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.contentInsets.trailing)
        ])
    }
    
    private func addloginButton() {
        loginButton.backgroundColor = .systemPurple
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(loginButton)
        NSLayoutConstraint.activate([
        loginButton.heightAnchor.constraint(equalToConstant: layout.buttonHeight),
        loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.contentInsets.leading),
        loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.contentInsets.trailing),
        loginButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -layout.contentInsets.bottom)
        ])

    }

}

private extension LoginViewController {
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

extension LoginViewController {
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
*/
