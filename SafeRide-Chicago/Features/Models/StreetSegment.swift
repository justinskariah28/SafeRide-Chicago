//
//  StreetSegment.swift
//  SafeRide-Chicago
//

import Foundation
import MapKit

// MARK: - Supporting Types

enum SidewalkCondition: String, Codable, Hashable {
    case poor
    case fair
    case good
    case excellent
}

enum CrossingDifficulty: String, Codable, Hashable {
    case easy
    case moderate
    case difficult
    case unknown
}

enum CrowdingLevel: String, Codable, Hashable {
    case low
    case moderate
    case high
    case unknown
}

extension CrowdingLevel {
    var routeScore: Double {
        switch self {
        case .low:
            return 5.0

        case .moderate:
            return 3.0

        case .high:
            return 0.0

        case .unknown:
            return 2.0
        }
    }
}

enum RouteObstacle: String, Codable, Hashable {
    case construction
    case brokenSidewalk
    case narrowSidewalk
    case blockedPath
    case other
}

// MARK: - Street Segment Model

struct StreetSegment: Identifiable, Codable, Hashable {
    let id: UUID

    let name: String

    let startIntersection: String
    let endIntersection: String

    let startLatitude: Double
    let startLongitude: Double

    let endLatitude: Double
    let endLongitude: Double

    // Rated from 1.0 through 5.0.
    let lightingScore: Double

    let isWheelchairAccessible: Bool
    let sidewalkCondition: SidewalkCondition
    let hasCurbRamps: Bool?

    let obstacles: [RouteObstacle]
    let crossingDifficulty: CrossingDifficulty
    let crowding: CrowdingLevel

    let nearbySafeSpotNames: [String]
    let notes: String
    let dateVerified: String?

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
        hasCurbRamps: Bool? = nil,
        obstacles: [RouteObstacle] = [],
        crossingDifficulty: CrossingDifficulty = .unknown,
        crowding: CrowdingLevel = .unknown,
        nearbySafeSpotNames: [String] = [],
        notes: String = "",
        dateVerified: String? = nil
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
        self.hasCurbRamps = hasCurbRamps
        self.obstacles = obstacles
        self.crossingDifficulty = crossingDifficulty
        self.crowding = crowding
        self.nearbySafeSpotNames = nearbySafeSpotNames
        self.notes = notes
        self.dateVerified = dateVerified
    }
}

// MARK: - Demo Area Data

extension StreetSegment {
    static let demoSegments: [StreetSegment] = [

        // MARK: Previously Added Segments

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
            notes: """
            Very well lit at night and suitable for wheelchair users.
            """
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
            notes: """
            Moderate nighttime lighting and sidewalk in good condition.
            """
        ),

        // MARK: Polk Street

        StreetSegment(
            name: "Polk Street",
            startIntersection: "Survey point on W Polk St",
            endIntersection: "W Polk St & S Racine Ave",
            startLatitude: 41.871889,
            startLongitude: -87.651750,
            endLatitude: 41.871806,
            endLongitude: -87.656861,
            lightingScore: 3.5,
            isWheelchairAccessible: true,
            sidewalkCondition: .good,
            hasCurbRamps: true,
            obstacles: [],
            crossingDifficulty: .easy,
            crowding: .low,
            nearbySafeSpotNames: [
                "Richard J. Daley Library"
            ],
            notes: "No major obstacles were observed."
        ),

        // MARK: Racine Avenue

        StreetSegment(
            name: "Racine Avenue",
            startIntersection: "S Racine Ave & W Harrison St",
            endIntersection: "S Racine Ave & W Taylor St",
            startLatitude: 41.874278,
            startLongitude: -87.656833,
            endLatitude: 41.869417,
            endLongitude: -87.656778,
            lightingScore: 3.0,
            isWheelchairAccessible: true,
            sidewalkCondition: .good,
            hasCurbRamps: true,
            obstacles: [],
            crossingDifficulty: .moderate,
            crowding: .low,
            nearbySafeSpotNames: [
                "Richard J. Daley Library"
            ],
            notes: "No major obstacles were observed."
        ),

        // MARK: Cabrini Street

        StreetSegment(
            name: "Cabrini Street",
            startIntersection: "W Cabrini St & S Racine Ave",
            endIntersection: "W Cabrini St & S Ada St",
            startLatitude: 41.871333,
            startLongitude: -87.656861,
            endLatitude: 41.871222,
            endLongitude: -87.660139,
            lightingScore: 2.0,
            isWheelchairAccessible: true,
            sidewalkCondition: .good,
            hasCurbRamps: true,
            obstacles: [],
            crossingDifficulty: .easy,
            crowding: .low,
            nearbySafeSpotNames: [
                "Richard J. Daley Library"
            ],
            notes: """
            Wheelchair accessible with good sidewalks, but nighttime
            lighting is below average.
            """
        ),

        // MARK: Lexington Street

        StreetSegment(
            name: "Lexington Street",
            startIntersection: "Survey point on W Lexington St",
            endIntersection: "W Lexington St & S Racine Ave",
            startLatitude: 41.872222,
            startLongitude: -87.661167,
            endLatitude: 41.872278,
            endLongitude: -87.656917,
            lightingScore: 2.0,
            isWheelchairAccessible: true,
            sidewalkCondition: .good,
            hasCurbRamps: true,
            obstacles: [],
            crossingDifficulty: .easy,
            crowding: .low,
            nearbySafeSpotNames: [
                "Richard J. Daley Library"
            ],
            notes: """
            Wheelchair accessible with good sidewalks, but nighttime
            lighting is below average.
            """
        )
    ]
}

