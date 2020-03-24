//
//  ArticleListViewController.swift
//  ArticleList
//
//  Created by KuanWei on 2020/1/31.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleListViewController: UIViewController {
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0;
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()

    var viewModel: ArticleListViewModel

    init(viewModel: ArticleListViewModel = ArticleListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Article List"

        collectionView.delegate = self
        collectionView.dataSource = self
        setupCollectionView()

        viewModelBinding()

        viewModel.requestArticlesAPI()
    }

    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        collectionView.register(ArticleListCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ArticleListCollectionViewCell.self))
    }


    func viewModelBinding() {
        viewModel.articleListDidChange = { [weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.navigationItem.title = "Article List (\(self.viewModel.getArticleCount()))"
            }
        }

        viewModel.selectedArticleClosure = { [weak self] article in
            DispatchQueue.main.async {
                guard let url = URL(string: article.url) else { return }
                let articleWebVC = ArticleWebViewController(viewModel: ArticleWebViewModel(url: url))
                self?.navigationController?.pushViewController(articleWebVC, animated: true)
            }
        }
    }
}

extension ArticleListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArticleListCollectionViewCell.self), for: indexPath) as? ArticleListCollectionViewCell else {
            return UICollectionViewCell()
        }

        let article = viewModel.getArticle(at: indexPath)

        cell.firstLabel.text = article?.title
        let imageUrlString = article?.img_list?.first
        let imageUrl = URL(string: imageUrlString!)
        cell.imageView.sd_setImage(with: imageUrl, completed: nil)

        return cell
    }
}

extension ArticleListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectArticle(at: indexPath)
    }
}

extension ArticleListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 41.0) / 2.0
        let height: CGFloat = 165.5
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 16, bottom: 28, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 42
    }
}
