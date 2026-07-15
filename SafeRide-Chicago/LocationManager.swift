//
//  LocationManager.swift
//  SafeRide-Chicago
//

import Combine
import CoreLocation
import Foundation

final class LocationManager:
    NSObject,
    ObservableObject,
    CLLocationManagerDelegate
{
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    @Published private(set) var locationError: String?

    private let manager = CLLocationManager()

    override init() {
        authorizationStatus = manager.authorizationStatus

        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
        manager.activityType = .fitness
    }

    func requestCurrentLocation() {
        locationError = nil

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        case .denied:
            locationError =
                "Location access is disabled. Enable it in Settings."

        case .restricted:
            locationError =
                "Location access is restricted on this device."

        @unknown default:
            locationError =
                "SafeRide could not determine your location permission."
        }
    }

    func startNavigationUpdates() {
        locationError = nil

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()

        case .denied:
            locationError =
                "Location access is disabled. Enable it in Settings."

        case .restricted:
            locationError =
                "Location access is restricted on this device."

        @unknown default:
            locationError =
                "SafeRide could not determine your location permission."
        }
    }

    func stopNavigationUpdates() {
        manager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus

            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.startUpdatingLocation()

            case .denied:
                self.locationError =
                    "Location access was denied."

            case .restricted:
                self.locationError =
                    "Location access is restricted."

            case .notDetermined:
                break

            @unknown default:
                self.locationError =
                    "SafeRide could not determine your location permission."
            }
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let newestLocation = locations.last else {
            return
        }

        // Ignore inaccurate GPS readings.
        guard newestLocation.horizontalAccuracy >= 0,
              newestLocation.horizontalAccuracy <= 100 else {
            return
        }

        DispatchQueue.main.async {
            self.currentLocation = newestLocation
            self.locationError = nil
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        DispatchQueue.main.async {
            self.locationError = error.localizedDescription
        }
    }
}
