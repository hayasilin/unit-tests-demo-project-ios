//
//  XCTestCase+Wait.swift
//  ArticleListUITests
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import XCTest

extension XCTestCase {
    enum UIStatus: String {
        case exist = "exists == true"
        case notExist = "exists == false"
        case selected = "selected == true"
        case notSelected = "selected == false"
        case hittable = "hittable == true"
        case unhittable = "hittable == false"
    }

    func tapWithExpect(element: XCUIElement?, status: UIStatus = .hittable, timeout: TimeInterval = 10) -> Bool {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: status.rawValue), object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)

        switch result {
        case .completed:
            element?.tap()
            return true
        default:
            return false
        }
    }
}
