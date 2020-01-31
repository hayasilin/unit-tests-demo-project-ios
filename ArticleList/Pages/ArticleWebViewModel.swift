//
//  ArticleWebViewModel.swift
//  ArticleList
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import Foundation

class ArticleWebViewModel {
    private(set) var url: URL?

    private(set) var title = "Article"

    init(url: URL) {
        self.url = url
    }
}
