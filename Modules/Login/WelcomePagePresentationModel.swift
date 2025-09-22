//
//  WelcomePagePresentationModel.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 11.09.2025.
//

import Foundation

struct WelcomePresentationModel {
    let imageName: String?
    let titleViewText: String
    let loginButtonTitle: String
    
    static let defaultWelcome = WelcomePresentationModel(
        imageName: "N11_logo",
        titleViewText: "N11'e Hoş Geldiniz!",
        loginButtonTitle: "Giriş Yap"
    )
}
