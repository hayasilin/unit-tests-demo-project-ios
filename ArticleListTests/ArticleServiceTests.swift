//
//  ArticleServiceTests.swift
//  ArticleListTests
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import XCTest
@testable import ArticleList

class ArticleServiceTests: XCTestCase {
    func testRequestWithError() {
        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)

        let mockApiClient = MockApiClient()
        mockApiClient.session = MockURLSession(data: nil, urlResponse: nil, error: error)
        let sut = ArticleService(apiClient: mockApiClient)

        let errorExpectation = expectation(description: #function)
        var catchedError: NSError? = nil

        sut.request { (data, error) in
            if let error = error {
                catchedError = error as NSError
                errorExpectation.fulfill()
            }
        }

        wait(for: [errorExpectation], timeout: 10)
        XCTAssertEqual(error.code, catchedError?.code)
    }

    func testRequestWithNilData() {
        let mockApiClient = MockApiClient()
        mockApiClient.session = MockURLSession(data: nil, urlResponse: nil, error: nil)
        let sut = ArticleService(apiClient: mockApiClient)

        let withoutDataExpectation = expectation(description: #function)

        sut.request { (data, error) in
            XCTAssertNil(data)
            withoutDataExpectation.fulfill()
        }

        wait(for: [withoutDataExpectation], timeout: 10)
    }

    func testRequestIsSuccess() throws {
        guard let data = try? APITester.getDataFromJSON(fileName: ArticleAPIResponseStatus.success.fileName) else {
            XCTFail()
            return
        }

        let mockApiClient = MockApiClient()
        mockApiClient.session = MockURLSession(data: data, urlResponse: nil, error: nil)
        let sut = ArticleService(apiClient: mockApiClient)

        let dataExpectation = expectation(description: #function)

        sut.request { (data, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            dataExpectation.fulfill()
        }

        wait(for: [dataExpectation], timeout: 10)
    }
}
