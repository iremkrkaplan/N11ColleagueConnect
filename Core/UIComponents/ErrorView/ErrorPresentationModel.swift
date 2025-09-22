//
//  ErrorPresentationModel.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 21.08.2025.
//

import Foundation

struct ErrorPresentationModel {
    let titleViewText: String
    let subtitleViewText: String
    let imageName: String?
    var retryButtonModel: RetryActionPresentationModel
    
    static let networkConnectionError = ErrorPresentationModel(
        titleViewText: "Oops!",
        subtitleViewText: "İnternet bağlantınızı kontrol edin",
        imageName: "NetworkErrorImage",
        retryButtonModel: .init(
            buttonTitle: "Yeniden Dene"
        )
    )
}

struct RetryActionPresentationModel {
    let buttonTitle: String
}
