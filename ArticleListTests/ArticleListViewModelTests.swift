//
//  ArticleListViewModelTests.swift
//  ArticleListTests
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import XCTest
@testable import ArticleList

class ArticleListViewModelTests: XCTestCase {
    func testRequestArticlesAPIIsSuccess() {
        let sut = ArticleListViewModel(articleService: MockArticleService(status: .success))

        let expect = expectation(description: #function)
        sut.articleListDidChange = {
            expect.fulfill()
        }

        sut.requestArticlesAPI()

        wait(for: [expect], timeout: 10)
    }

    func testRequestArticlesIsError() {
        let sut = ArticleListViewModel(articleService: MockArticleService(status: .error))

        let expect = expectation(description: #function)
        sut.requestArticlesFail = { error in
            XCTAssertNotNil(error)
            expect.fulfill()
        }

        sut.requestArticlesAPI()

        wait(for: [expect], timeout: 10)
    }

    func testRequestArticlesIsNilData() {
        let sut = ArticleListViewModel(articleService: MockArticleService(status: .nilData))

        let expect = expectation(description: #function)
        sut.requestArticlesFail = { error in
            XCTAssertNil(error)
            expect.fulfill()
        }

        sut.requestArticlesAPI()

        wait(for: [expect], timeout: 10)
    }

    func testSelectArticle() {
        let sut = ArticleListViewModel(articleService: MockArticleService(status: .success))
        var urlString: String?

        let expect = XCTestExpectation(description: #function)
        sut.selectedArticleClosure = { article in
            urlString = article.url
            expect.fulfill()
        }

        sut.requestArticlesAPI()
        sut.selectArticle(at: IndexPath(row: 0, section: 0))

        wait(for: [expect], timeout: 10)
        XCTAssertNotNil(urlString)
    }
}

class MockArticleService: ArticleService {
    enum Status {
        case success
        case error
        case nilData
    }

    var status: Status = .success

    init() {
        super.init()
    }

    convenience init(status: Status = .success) {
        self.init()
        self.status = status
    }

    override func request(completionHandler: @escaping (List?, Error?) -> Void) {
        switch status {
        case .success:
            guard let data = try? APITester.getDataFromJSON(fileName: ArticleAPIResponseStatus.success.fileName) else {
                completionHandler(nil, nil)
                return
            }
            guard let articles = try? JSONDecoder().decode(List.self, from: data) else {
                completionHandler(nil, nil)
                return
            }
            completionHandler(articles, nil)

        case .error:
            let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
            completionHandler(nil, error)

        case .nilData:
            completionHandler(nil, nil)
        }
    }
}
