//
//  ArticleListCollectionViewCell.swift
//  ArticleList
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import UIKit

class ArticleListCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var firstLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(firstLabel)

        NSLayoutConstraint.activate([
            // imageView
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 110),
            // firstLabel
            firstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 9),
            firstLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
