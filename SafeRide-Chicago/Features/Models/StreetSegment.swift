import Foundation
import MapKit

enum SidewalkCondition: String, Codable, Hashable {
    case poor
    case fair
    case good
    case excellent
}

struct StreetSegment: Identifiable, Codable, Hashable {
    let id: UUID

    let name: String

    let startIntersection: String
    let endIntersection: String

    let startLatitude: Double
    let startLongitude: Double

    let endLatitude: Double
    let endLongitude: Double

    let lightingScore: Double
    let isWheelchairAccessible: Bool
    let sidewalkCondition: SidewalkCondition
    let notes: String

    var startCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: startLatitude,
            longitude: startLongitude
        )
    }

    var endCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: endLatitude,
            longitude: endLongitude
        )
    }

    var coordinates: [CLLocationCoordinate2D] {
        [
            startCoordinate,
            endCoordinate
        ]
    }

    init(
        id: UUID = UUID(),
        name: String,
        startIntersection: String,
        endIntersection: String,
        startLatitude: Double,
        startLongitude: Double,
        endLatitude: Double,
        endLongitude: Double,
        lightingScore: Double,
        isWheelchairAccessible: Bool,
        sidewalkCondition: SidewalkCondition,
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.startIntersection = startIntersection
        self.endIntersection = endIntersection
        self.startLatitude = startLatitude
        self.startLongitude = startLongitude
        self.endLatitude = endLatitude
        self.endLongitude = endLongitude
        self.lightingScore = lightingScore
        self.isWheelchairAccessible = isWheelchairAccessible
        self.sidewalkCondition = sidewalkCondition
        self.notes = notes
    }
}

extension StreetSegment {
    static let demoSegments: [StreetSegment] = [
        StreetSegment(
            name: "Taylor Street",
            startIntersection: "Taylor St & S Halsted St",
            endIntersection: "Taylor St & S Laflin St",
            startLatitude: 41.869515,
            startLongitude: -87.647372,
            endLatitude: 41.869255,
            endLongitude: -87.664265,
            lightingScore: 5.0,
            isWheelchairAccessible: true,
            sidewalkCondition: .good,
            notes: "Very well lit at night and suitable for wheelchair users."
        ),

        StreetSegment(
            name: "Harrison Street",
            startIntersection: "W Harrison St & S Loomis St",
            endIntersection: "W Harrison St & S Halsted St",
            startLatitude: 41.874268,
            startLongitude: -87.661926,
            endLatitude: 41.873843,
            endLongitude: -87.647261,
            lightingScore: 3.5,
            isWheelchairAccessible: true,
            sidewalkCondition: .good,
            notes: "Moderate nighttime lighting and sidewalk in good condition."
        )
    ]
}
