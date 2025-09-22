//
//  GitHubTokenResponse.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 10.09.2025.
//

import Foundation

struct GitHubTokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
}
