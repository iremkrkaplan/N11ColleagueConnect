//  LoginPresentationModel.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 10.09.2025.
//

import Foundation

struct LoginViewData {
    let githubLoginURL: URL
    let customURLScheme: String
    let codeQueryItemName: String
    let loginButtonModel: NavigateToGitHubButtonPresentationModel
    let infoTitleText: String
}

struct NavigateToGitHubButtonPresentationModel {
    let title: String
    let url: URL?
    let action: () -> Void
}
