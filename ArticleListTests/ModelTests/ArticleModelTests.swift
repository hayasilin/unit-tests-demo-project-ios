//
//  ArticleModelTests.swift
//  ArticleListTests
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import XCTest
@testable import ArticleList

class ArticleModelTests: XCTestCase {
    func testDecodeResponseIsSuccess() {
        guard let data = try? APITester.getDataFromJSON(fileName: ArticleAPIResponseStatus.success.fileName) else {
            XCTFail()
            return
        }
        guard let articles = try? JSONDecoder().decode(List.self, from: data) else {
            XCTFail()
            return
        }

        XCTAssertEqual(14, articles.list.count)
    }

    func testDecodeResponseIsEmptyData() {
        guard let data = try? APITester.getDataFromJSON(fileName: ArticleAPIResponseStatus.empty.fileName) else {
            XCTFail()
            return
        }
        guard let articles = try? JSONDecoder().decode(List.self, from: data) else {
            XCTFail()
            return
        }

        XCTAssertEqual(0, articles.list.count)
    }
}
