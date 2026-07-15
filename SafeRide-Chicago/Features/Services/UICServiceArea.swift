import MapKit

enum UICServiceArea {

    // Approximate supported area:
    // North: Harrison Street
    // South: Roosevelt Road
    // West: Damen Avenue
    // East: Halsted Street

    static let northLatitude = 41.8752
    static let southLatitude = 41.8668
    static let westLongitude = -87.6775
    static let eastLongitude = -87.6460

    static let center = CLLocationCoordinate2D(
        latitude: (northLatitude + southLatitude) / 2,
        longitude: (westLongitude + eastLongitude) / 2
    )

    static let region = MKCoordinateRegion(
        center: center,
        span: MKCoordinateSpan(
            latitudeDelta: northLatitude - southLatitude,
            longitudeDelta: eastLongitude - westLongitude
        )
    )

    static func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let insideLatitude =
            coordinate.latitude >= southLatitude &&
            coordinate.latitude <= northLatitude

        let insideLongitude =
            coordinate.longitude >= westLongitude &&
            coordinate.longitude <= eastLongitude

        return insideLatitude && insideLongitude
    }

    static func containsEntireRoute(_ route: MKRoute) -> Bool {
        let points = route.polyline.points()

        for index in 0..<route.polyline.pointCount {
            let coordinate = points[index].coordinate

            if !contains(coordinate) {
                return false
            }
        }

        return true
    }
}
