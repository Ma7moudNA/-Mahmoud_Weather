//
//  LocationManager.swift
//  Mahmoud_Weather
//
//  Student: Mahmoud Al Nakawa (ID: 991745131)
//

import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var lastError: String?

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 200
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // User granted location access → start getting updates
            lastError = nil
            self.manager.startUpdatingLocation()
        case .denied, .restricted:
            // User denied location access
            self.manager.stopUpdatingLocation()
            lastError = "Location access is denied."
        case .notDetermined:
            // Permission not yet asked → request it
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // When a new location is received, update coordinates
        guard let loc = locations.last else { return }
        latitude  = loc.coordinate.latitude
        longitude = loc.coordinate.longitude
        // Clear any previous error once we have a valid location
        lastError = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle any location update failure
        lastError = error.localizedDescription
    }
}
