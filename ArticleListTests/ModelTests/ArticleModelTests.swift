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
    func testDecodeResponseIsSuccess() throws {
        let data = (try APITester.getDataFromJSON(fileName: ArticleAPIResponseStatus.success.fileName))!
        let articles = try JSONDecoder().decode(List.self, from: data)

        XCTAssertEqual(14, articles.list.count)
    }

    func testDecodeResponseIsEmptyData() throws {
        let data = (try APITester.getDataFromJSON(fileName: ArticleAPIResponseStatus.empty.fileName))!
        let articles = try JSONDecoder().decode(List.self, from: data)

        XCTAssertEqual(0, articles.list.count)
    }
}
