//
//  LoginInteractor.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 10.09.2025.
//

import Foundation
import KeychainSwift

final class LoginInteractor: LoginInteractorInput {
    
    weak var output: LoginInteractorOutput?
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    private var clientID: String {
        guard let clientID = Bundle.main.infoDictionary?["GITHUB_CLIENT_ID"] as? String else {
            fatalError("Error: Missing GITHUB_CLIENT_ID in Info.plist")
        }
        return clientID
    }
    
    private var clientSecret: String {
        guard let clientSecret = Bundle.main.infoDictionary?["GITHUB_CLIENT_SECRET"] as? String else {
            fatalError("Error: Missing GITHUB_CLIENT_SECRET in Info.plist")
        }
        return clientSecret
    }

    private let redirectURI = "n11peopleproject://auth"
    
    func generateAuthorizationURL() {
        var components = URLComponents(string: "https://github.com/login/oauth/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: "user,repo")
        ]
        if let url = components.url {
            output?.didGenerateAuthorizationURL(url)
        }
    }
    
    func exchangeCodeForToken(code: String) {
        Task {
            do {
                let params = GitHubOAuthParams(
                    clientID: clientID,
                    clientSecret: clientSecret,
                    code: code,
                    redirectURI: redirectURI
                )
                
                let tokenResponse = try await apiClient.getAccessToken(params)
            
                output?.didSuccessfullyAuthenticate()
            } catch {

            }
        }
    }
}

