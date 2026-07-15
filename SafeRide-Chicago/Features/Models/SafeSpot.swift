import Foundation
import MapKit

enum SeatingAvailability: String, Codable, Hashable {
    case none
    case inside
    case outside
    case insideAndOutside
}

struct SafeSpot: Identifiable, Codable, Hashable {
    let id: UUID

    let name: String
    let address: String

    let latitude: Double
    let longitude: Double

    let isWheelchairAccessible: Bool
    let isWellLit: Bool
    let seating: SeatingAvailability
    let notes: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }

    init(
        id: UUID = UUID(),
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
        isWheelchairAccessible: Bool,
        isWellLit: Bool,
        seating: SeatingAvailability,
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.isWheelchairAccessible = isWheelchairAccessible
        self.isWellLit = isWellLit
        self.seating = seating
        self.notes = notes
    }
}

extension SafeSpot {
    static let demoSafeSpots: [SafeSpot] = [
        SafeSpot(
            name: "Richard J. Daley Library",
            address: "801 S Morgan St, Chicago, IL",
            latitude: 41.8698,
            longitude: -87.6510,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .insideAndOutside,
            notes: "Seating is available inside and outside."
        ),

        SafeSpot(
            name: "Academic and Residential Complex",
            address: "940 W Harrison St, Chicago, IL",
            latitude: 41.86948,
            longitude: -87.65036,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .insideAndOutside,
            notes: "Seating is available inside and outside."
        ),

        SafeSpot(
            name: "UIC Student Recreation Facility",
            address: "737 S Halsted St, Chicago, IL",
            latitude: 41.8753,
            longitude: -87.6481,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .inside,
            notes: "Indoor seating is available."
        )
    ]
}
