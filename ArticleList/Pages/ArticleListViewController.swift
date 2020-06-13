//
//  ArticleListViewController.swift
//  ArticleList
//
//  Created by KuanWei on 2020/1/31.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import UIKit

class ArticleListViewController: UIViewController {
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0;
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()

    var viewModel: ArticleListViewModel

    private var urls: [URL] = []

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

        getImageUrls()
    }

    func getImageUrls() {
        guard let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
              let contents = try? Data(contentsOf: plist),
              let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
              let serialUrls = serial as? [String] else {
          print("Something went horribly wrong!")
          return
        }

        urls = serialUrls.compactMap { URL(string: $0) }
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

    private func downloadWithGlobalQueue(at indexPath: IndexPath) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else {
                return
            }

            let url = self.urls[indexPath.item]
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                if let cell = self.collectionView.cellForItem(at: indexPath) as? ArticleListCollectionViewCell {
                    cell.display(image: image)
                }
            }
        }
    }

    private func downloadWithURLSession(at indexPath: IndexPath) {
        URLSession.shared.dataTask(with: urls[indexPath.row]) { [weak self] (data, response, error) in
            guard let self = self, let data = data, let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                if let cell = self.collectionView.cellForItem(at: indexPath) as? ArticleListCollectionViewCell {
                    cell.display(image: image)
                }
            }
        }.resume()
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

        cell.display(image: nil)

        let article = viewModel.getArticle(at: indexPath)

        cell.firstLabel.text = article?.title

//        downloadWithGlobalQueue(at: indexPath)
        downloadWithURLSession(at: indexPath) // A way that Apple already handle for you.

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
