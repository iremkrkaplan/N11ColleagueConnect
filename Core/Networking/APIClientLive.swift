//
//  APIClientLive.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 17.08.2025.
//

import Foundation
import KeychainSwift

struct GetAuthenticatedUserEndpoint: Endpoint {
    
    func urlRequest() -> URLRequest {
        let url = url(appendingPath: "/user")
        return URLRequest(url: url)
    }
}

extension Endpoint where Self == GetAuthenticatedUserEndpoint {
    static func getAuthenticatedUser() -> Self {
        .init()
    }
}

struct SearchUsersEndpoint: Endpoint {
    private let params: SearchUsersParams
    init(params: SearchUsersParams) { self.params = params }
    
    func urlRequest() -> URLRequest {
        var components = URLComponents(url: url(appendingPath: "/search/users"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "q", value: params.query)]
        return URLRequest(url: components.url!)
    }
}

extension Endpoint where Self == SearchUsersEndpoint {
    static func searchUsers(params: SearchUsersParams) -> Self { .init(params: params) }
}

struct GetUserDetailEndpoint: Endpoint {
    private let params: GetUserDetailParams
    init(params: GetUserDetailParams) { self.params = params }
    
    func urlRequest() -> URLRequest {
        let url = url(appendingPath: "/users/\(params.username)")
        return URLRequest(url: url)
    }
}

extension Endpoint where Self == GetUserDetailEndpoint {
    static func getUserDetail(params: GetUserDetailParams) -> Self { .init(params: params) }
}

struct GetFollowersEndpoint: Endpoint {
    private let params: GetFollowersParams
    init(params: GetFollowersParams) { self.params = params }
    
    func urlRequest() -> URLRequest {
        let url = url(appendingPath: "/users/\(params.username)/followers")
        return URLRequest(url: url)
    }
}

extension Endpoint where Self == GetFollowersEndpoint {
    static func getFollowers(params: GetFollowersParams) -> Self { .init(params: params) }
}

struct GetFollowingEndpoint: Endpoint {
    private let params: GetFollowingParams
    init(params: GetFollowingParams) { self.params = params }
    
    func urlRequest() -> URLRequest {
        let url = url(appendingPath: "/users/\(params.username)/following")
        return URLRequest(url: url)
    }
}

extension Endpoint where Self == GetFollowingEndpoint {
    static func getFollowing(params: GetFollowingParams) -> Self { .init(params: params) }
}


struct GetAccessTokenEndpoint: Endpoint {
    private let params: GitHubOAuthParams
    private let authURL = URL(string: "https://github.com/login/oauth/access_token")!

    init(params: GitHubOAuthParams) { self.params = params }

    func urlRequest() -> URLRequest {
        var request = URLRequest(url: authURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParams = [
            "client_id": params.clientID,
            "client_secret": params.clientSecret,
            "code": params.code,
            "redirect_uri": params.redirectURI,
            "state": params.state
        ].compactMapValues { $0 }
        .map { "\($0.key)=\($0.value)" }
        .joined(separator: "&")

        request.httpBody = bodyParams.data(using: .utf8)
        return request
    }
}

extension Endpoint where Self == GetAccessTokenEndpoint {
    static func getAccessToken(params: GitHubOAuthParams) -> Self { .init(params: params) }
}

extension APIClient {
    public static let live: Self = {
        var client = Self.noop
        
        client.getAuthenticatedUser = { try await request(.getAuthenticatedUser()) }
        client.searchUsers = { params in try await request(.searchUsers(params: params)) }
        client.getUserDetail = { try await request(.getUserDetail(params: $0)) }
        client.getFollowers = { try await request(.getFollowers(params: $0)) }
        client.getFollowing = { try await request(.getFollowing(params: $0)) }
        client.getAccessToken = { params in
            let response: GitHubAccessTokenResponse = try await request(.getAccessToken(params: params))
            let keychain = KeychainSwift()
            keychain.set(response.accessToken, forKey: "github_access_token")
            return response
        }
        return client
    }()
}

private extension APIClient {
    
    static var githubDateDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    static var githubToken: String {
        let keychain = KeychainSwift()
        
        if let oauthToken = keychain.get("github_access_token") {
            return oauthToken
        }
        
        guard let token = Bundle.main.infoDictionary?["API_TOKEN"] as? String,
              !token.isEmpty else {
            fatalError("API_TOKEN not found in Info.plist. Please check your xcconfig setup.")
        }
        return token
    }
    
    static func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = endpoint.urlRequest()
        
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        if !(endpoint is GetAccessTokenEndpoint) {
            request.addValue("Bearer \(githubToken)", forHTTPHeaderField: "Authorization")
        }
//        request.addValue("Bearer \(githubToken)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        if T.self == GitHubAccessTokenResponse.self {
            return try JSONDecoder().decode(T.self, from: data)
        }
        
        return try githubDateDecoder.decode(T.self, from: data)
    }
}
