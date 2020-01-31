//
//  Article.swift
//  ArticleList
//
//  Created by KuanWei on 2020/1/31.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import Foundation

struct List: Codable {
    let list: [Article]
}

struct Article: Codable {
    let author: String?
    let title: String?
    let board_name: String?
    let desc: String?
    let url: String
    let img_list:[String]?

    private enum CodingKeys: String, CodingKey {
        case author
        case title
        case board_name
        case desc
        case url
        case img_list
    }
}
