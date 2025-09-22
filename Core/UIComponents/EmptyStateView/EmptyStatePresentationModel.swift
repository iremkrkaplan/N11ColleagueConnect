//
//  EmptyStatePresentationModel.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 8.09.2025.
//

import Foundation

struct EmptyStatePresentationModel {
    let titleViewText: String
    let subtitleViewText: String
    let imageName: String?
    
    static let emptyState = EmptyStatePresentationModel(
        titleViewText: "Favori listeniz boş!",
        subtitleViewText: "Kalp ikonuna tıklayarak kişileri favoriye ekleyebilirsiniz!",
        imageName: "PlaceHolder"
    )
    
    static let searchEmptyState = EmptyStatePresentationModel(titleViewText: "N11 çalışanlarını arayın!", subtitleViewText: "Arama ikonuna tıklayarak aradığınız kişiyi bulabilirsiniz", imageName: "hello-kitty-investigate")
}
