//
//  APITester.swift
//  ArticleListTests
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import Foundation

enum ArticleAPIResponseStatus {
    case success
    case empty

    var fileName: String {
        switch self {
        case .success:
            return "ArticleAPIResponseSuccess"
        case .empty:
            return "ArticleAPIResponseEmptyData"
        }
    }
}

class APITester {
    static func getDataFromJSON(fileName: String) throws -> Data? {
        let path = Bundle(for: self).path(forResource: fileName, ofType: "json")!
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
}
