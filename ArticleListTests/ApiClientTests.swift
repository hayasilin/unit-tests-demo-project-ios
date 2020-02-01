//
//  ApiClientTests.swift
//  ArticleListTests
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import XCTest
@testable import ArticleList

class ApiClientTests: XCTestCase {

    var sut = MockApiClient()
    var mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)

    override func setUp() {
        sut.session = mockURLSession
    }

    func testRequestWithUrl() {
        let completion = { (data: Data?, response: URLResponse?, error: Error?) in }
        sut.requestData(url: URL(string: "https://unittesting.com")!, completionHandler: completion)
        XCTAssertEqual(mockURLSession.urlComponents?.host, "unittesting.com")
    }

    func testRequestWithUrlRequest() {
        let completion = { (data: Data?, response: URLResponse?, error: Error?) in }
        let urlRequest = URLRequest(url: URL(string: "https://unittesting.com")!)
        sut.requestData(urlRequest: urlRequest, completionHandler: completion)
        XCTAssertEqual(mockURLSession.urlRequest, urlRequest)
    }

    func testWhenJsonIsInvalidReturnError() {
        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
        let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)

        sut.session = MockURLSession(data: jsonData, urlResponse: nil, error: error)

        let errorExpectation = expectation(description: #function)
        var catchedJsonDictionary: [String: Any]? = nil
        var catchedError: Error? = nil

        let urlRequest = URLRequest(url: URL(string: "https://unittesting.com")!)
        sut.requestData(urlRequest: urlRequest) { (data, response, error) in
            guard let data = data else {
                return
            }
            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonResponse as? [String: Any] else {
                return
            }

            catchedJsonDictionary = jsonDictionary
            catchedError = error
            errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(catchedJsonDictionary)
            XCTAssertNotNil(catchedError)
        }
    }
}

class MockApiClient: ApiClient {
    override func requestData(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlRequest = URLRequest(url: URL(string:"https://unittesting.com")!)
        let dataTask = session.dataTask(with: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
    }
}

class MockURLSession: SessionProtocol {
    var url: URL?
    var urlRequest: URLRequest?
    private let dataTask: MockTask

    var urlComponents: URLComponents? {
        guard let url = url else { return nil }
        return URLComponents(url: url, resolvingAgainstBaseURL: true)
    }

    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        dataTask = MockTask(data: data,
                            urlResponse: urlResponse,
                            error: error)
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.urlRequest = request
        dataTask.completionHandler = completionHandler
        return dataTask
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        dataTask.completionHandler = completionHandler
        return dataTask
    }
}

class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let responseError: Error?
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    var completionHandler: CompletionHandler?
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data

        self.urlResponse = urlResponse
        self.responseError = error
    }
    override func resume() {
        DispatchQueue.main.async() {
            self.completionHandler?(self.data, self.urlResponse, self.responseError)
        }
    }
}
