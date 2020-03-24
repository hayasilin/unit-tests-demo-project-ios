//
//  ArticleService.swift
//  ArticleList
//
//  Created by KuanWei on 2020/1/31.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import Foundation

class ArticleService {
    let url = URL(string: "https://disp.cc/api/hot_text.json")!

    private var apiClient: ApiClientProtocol?

    init(apiClient: ApiClientProtocol = ApiClient()) {
        self.apiClient = apiClient
    }

    func request(completionHandler: @escaping (List?, Error?) -> Void) {
        let request = createRequest()

        apiClient?.requestData(urlRequest: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }

            guard let data = data else {
                let error = NSError(domain: "article list", code: NSURLErrorBadServerResponse, userInfo: nil)
                completionHandler(nil, error)
                return
            }

            do {
                let articleList = try self.parseResponse(data: data)
                completionHandler(articleList, nil)
            } catch let e as NSError {
                completionHandler(nil, e)
            }
        }
    }

    // MARK: - Private

    private func createRequest() -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        return urlRequest
    }

    private func parseResponse(data: Data) throws -> List {
        return try JSONDecoder().decode(List.self, from: data)
    }
}
