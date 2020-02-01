//
//  ArticleWebViewModelTests.swift
//  ArticleListTests
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import XCTest
@testable import ArticleList

class ArticleWebViewModelTests: XCTestCase {

    func testUrl() {
        let expectedURL = URL(string: "http://disp.cc/b/163-c3Az")!
        let sut = ArticleWebViewModel(url: expectedURL)

        XCTAssertEqual(expectedURL.absoluteURL, sut.url)
    }

}
