//
//  ApiClient.swift
//  ArticleList
//
//  Created by KuanWei on 2020/1/31.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension SessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
        return dataTask
    }
}

extension URLSession: SessionProtocol {}

protocol ApiClientProtocol {
    func requestData(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)

    func requestData(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class ApiClient: ApiClientProtocol {
    lazy var session: SessionProtocol = URLSession.shared

    func requestData(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = session.dataTask(with: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
    }

    func requestData(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = session.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
    }
}
