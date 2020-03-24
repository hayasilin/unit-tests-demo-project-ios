//
//  ArticleListViewModel.swift
//  ArticleList
//
//  Created by KuanWei on 2020/1/31.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import Foundation

class ArticleListViewModel {
    var articleListDidChange: (() -> Void)?

    var requestArticlesFail: ((_ error: Error?) -> Void)?

    var selectedArticleClosure: ((Article) -> Void)?

    private var articleList = [Article]()

    private var articleService: ArticleService?

    private let userDefaults: UserDefaults

    init(articleService: ArticleService = ArticleService(), userDefault: UserDefaults = UserDefaults.standard) {
        self.articleService = articleService
        self.userDefaults = userDefault
    }

    func requestArticlesAPI() {
        articleService?.request(completionHandler: { [weak self] (data, error) in
            guard error == nil else {
                self?.requestArticlesFail?(error)
                return
            }

            guard let data = data else {
                self?.requestArticlesFail?(error)
                return
            }

            self?.configureData(data)
        })
    }

    func numberOfRows() -> Int {
        return articleList.count
    }

    func getArticle(at indexPath: IndexPath) -> Article? {
        guard articleList.count > indexPath.row else { return nil }
        return articleList[indexPath.row]
    }

    func selectArticle(at indexPath: IndexPath) {
        guard let article = getArticle(at: indexPath) else { return }
        selectedArticleClosure?(article)
    }

    func getArticleCount() -> Int {
        return userDefaults.integer(forKey: "ArticleCount")
    }

    // MARK: private

    private func configureData(_ data: List) {
        self.articleList = data.list
        userDefaults.set(data.list.count, forKey: "ArticleCount")
        articleListDidChange?()
    }
}
