//
//  SafeSpot.swift
//  SafeRide-Chicago
//

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
            latitude: 41.871897,
            longitude: -87.650271,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .insideAndOutside,
            notes: "Seating is available inside and outside."
        ),

        SafeSpot(
            name: "Academic and Residential Complex",
            address: "940 W Harrison St, Chicago, IL",
            latitude: 41.874780,
            longitude: -87.650880,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .insideAndOutside,
            notes: "Seating is available inside and outside."
        ),

        SafeSpot(
            name: "UIC Student Recreation Facility",
            address: "737 S Halsted St, Chicago, IL",
            latitude: 41.872454,
            longitude: -87.646303,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .inside,
            notes: "Indoor seating is available."
        ),

        SafeSpot(
            name: "Rush Specialty Hospital",
            address: "516 S Loomis St, Chicago, IL 60607",
            latitude: 41.874583,
            longitude: -87.662139,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .inside,
            notes: "Hospital lobby and indoor seating are available."
        ),

        SafeSpot(
            name: "Credit Union 1 Arena",
            address: "525 S Racine Ave, Chicago, IL 60607",
            latitude: 41.874699,
            longitude: -87.656136,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .inside,
            notes: "Indoor seating may depend on arena hours and events."
        ),

        SafeSpot(
            name: "Behavioral Sciences Building",
            address: "1007 W Harrison St, Chicago, IL 60607",
            latitude: 41.873626,
            longitude: -87.653160,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .inside,
            notes: "Indoor seating and elevator access are available."
        ),
        SafeSpot(
            name: "Taco Bell",
            address: "1429 W Taylor St, Chicago, IL 60607",
            latitude: 41.869194,
            longitude: -87.662917,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .inside,
            notes: "Indoor seating"
        ),
        SafeSpot(
            name: "UIC Student Center East",
            address: "750 S Halsted St, Chicago, IL 60607",
            latitude: 41.871861,
            longitude: -87.647944,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .inside,
            notes: "Indoor seating and elevator access are available"
            ),
        SafeSpot(
            name: "Science and Engineering South",
            address: "901 W Taylor St, Chicago, IL 60607",
            latitude: 41.869139,
            longitude: -87.648611,
            isWheelchairAccessible: true,
            isWellLit: true,
            seating: .inside,
            notes: "Indoor seating and elevator access are available"
            )
    ]
}
