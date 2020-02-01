//
//  LocationManager.swift
//  ArticleList
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationFetcher {
    var locationFetcherDelegate: LocationFetcherDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    func requestLocation()
}

protocol LocationFetcherDelegate: class {
    func locationFetcher(_ fetcher: LocationFetcher, didUpdateLocations locations: [CLLocation])
}

extension CLLocationManager: LocationFetcher {
    var locationFetcherDelegate: LocationFetcherDelegate? {
        get { return delegate as! LocationFetcherDelegate? }
        set { delegate = newValue as! CLLocationManagerDelegate? }
    }
}

class LocationManager: NSObject {

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        return locationManager
    }()

    var currentLocationCheckCallback: ((CLLocation) -> Void)?

    private var locationFetcher: LocationFetcher

    init(locationFetcher: LocationFetcher = CLLocationManager()) {
        self.locationFetcher = locationFetcher
        super.init()
        self.locationFetcher.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationFetcher.locationFetcherDelegate = self
    }

    func requestLocation(completion: @escaping (Bool, CLLocation) -> Void) {
        self.currentLocationCheckCallback = { [unowned self] location in
            completion(self.isPointOfInterest(location), location)
        }
        locationFetcher.requestLocation()
        requestLocation()
    }

    func isPointOfInterest(_ location: CLLocation) -> Bool {
        return true
    }

    private func requestLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: LocationFetcherDelegate {

    func locationFetcher(_ fetcher: LocationFetcher, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocationCheckCallback?(location)
        self.currentLocationCheckCallback = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationFetcher(manager, didUpdateLocations: locations)
        locationManager.delegate = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
}
