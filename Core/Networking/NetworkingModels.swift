//
//  NetworkingModels.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 18.08.2025.
//

import Foundation

public protocol Endpoint {
    func urlRequest() -> URLRequest
}

public extension Endpoint {
    func url(appendingPath path: String) -> URL {
        URL(string: "https://api.github.com\(path)")!
    }
}

public struct SearchUsersParams {
    public let query: String
    public init(query: String) { self.query = query }
}

public struct GetUserDetailParams {
    public let username: String
    public init(username: String) { self.username = username }
}

public struct GetFollowersParams {
    public let username: String
    public init(username: String) { self.username = username }
}

public struct GetFollowingParams {
    public let username: String
    public init(username: String) { self.username = username }
}

public struct GitHubAccessTokenResponse: Decodable {
    public let accessToken: String
    public let tokenType: String
    public let scope: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
}

public struct GitHubOAuthParams {
    public let clientID: String
    public let clientSecret: String
    public let code: String
    public let redirectURI: String
    public let state: String?
    
    public init(clientID: String, clientSecret: String, code: String, redirectURI: String, state: String? = nil) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.code = code
        self.redirectURI = redirectURI
        self.state = state
    }
}
