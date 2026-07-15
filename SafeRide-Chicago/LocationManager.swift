import CoreLocation
import Foundation
import Combine

final class LocationManager:
    NSObject,
    ObservableObject,
    CLLocationManagerDelegate
{
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var authorizationStatus:
        CLAuthorizationStatus
    @Published private(set) var locationError: String?

    private let manager = CLLocationManager()

    override init() {
        authorizationStatus = manager.authorizationStatus

        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
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
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        default:
            locationError =
                "SafeRide needs location access for navigation."
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
                manager.requestLocation()

            case .denied:
                self.locationError =
                    "Location access was denied."

            case .restricted:
                self.locationError =
                    "Location access is restricted."

            default:
                break
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
