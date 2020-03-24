//
//  LocationManagerTests.swift
//  ArticleListTests
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ArticleList

class LocationManagerTests: XCTestCase {
    struct MockLocationFetcher: LocationFetcher {
        weak var locationFetcherDelegate: LocationFetcherDelegate?

        var desiredAccuracy: CLLocationAccuracy = 0

        var handleRequestLocation: (() -> CLLocation)?
        func requestLocation() {
            guard let location = handleRequestLocation?() else { return }
            locationFetcherDelegate?.locationFetcher(self, didUpdateLocations: [location])
        }
    }

    func testLocationManager() {
        var locationFetcher = MockLocationFetcher()
        let requestLocationExpectation = expectation(description: "request location")
        locationFetcher.handleRequestLocation = {
            requestLocationExpectation.fulfill()
            return CLLocation(latitude: 37.3293, longitude: -121.8893)
        }

        let sut = LocationManager(locationFetcher: locationFetcher)
        let completionExpectation = expectation(description: #function)
        sut.requestLocation { (isPointOfInterest, location) in
            XCTAssertTrue(isPointOfInterest)
            XCTAssertNotNil(location)
            completionExpectation.fulfill()
        }

        wait(for: [requestLocationExpectation, completionExpectation], timeout: 10)
    }
}
