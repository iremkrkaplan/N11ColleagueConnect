//
//  EmptyStateView.swift
//  N11PeopleProject
//
//  Created by irem.karakaplan on 8.09.2025.
//

import UIKit

final class EmptyStateView: UIView {
    private lazy var imageView: UIImageView = .build()
    private lazy var titleView: UILabel = .build()
    private lazy var subtitleView: UILabel = .build()
    private let layout: Layout = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ model: EmptyStatePresentationModel){
        titleView.text = model.titleViewText
        subtitleView.text = model.subtitleViewText
        
        if let imageName = model.imageName {
            imageView.image = UIImage(named: imageName)
        } else {
            imageView.image = nil
        }
    }
}

private extension EmptyStateView{
    
    func addUI(){
        self.backgroundColor = .systemBackground
        addImageView()
        addTitleView()
        addSubtitleView()
    }
    
    func addImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -layout.imageBottomOffsetFromCenter),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: layout.imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: layout.imageSize.height)
        ])
    }
    
    func addTitleView() {
        titleView.font = .systemFont(ofSize: layout.titleFontSize, weight: .bold)
        titleView.textAlignment = .center
        titleView.textColor = .label
        titleView.numberOfLines = 0
        
        addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: layout.titleTopPadding),
            titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: layout.horizontalPadding),
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -layout.horizontalPadding)
        ])
    }
    
    func addSubtitleView() {
        subtitleView.font = .systemFont(ofSize: layout.subtitleFontSize, weight: .medium)
        subtitleView.textAlignment = .center
        subtitleView.textColor = .secondaryLabel
        subtitleView.numberOfLines = 0
        
        addSubview(subtitleView)
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: layout.subtitleTopPadding),
            subtitleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: layout.horizontalPadding),
            subtitleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -layout.horizontalPadding)
        ])
    }
}

private extension EmptyStateView {
    struct Layout {
        let imageSize: CGSize = .init(width: 120, height: 120)
        let imageBottomOffsetFromCenter: CGFloat = 80
        
        let titleTopPadding: CGFloat = 32
        let subtitleTopPadding: CGFloat = 12
        let buttonTopPadding: CGFloat = 40
        
        let horizontalPadding: CGFloat = 24
        let buttonHeight: CGFloat = 50
        
        let titleFontSize: CGFloat = 30
        let subtitleFontSize: CGFloat = 16
        let buttonTitleFontSize: CGFloat = 18
    }
}
