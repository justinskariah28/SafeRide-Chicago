//
//  AccessibleArea.swift
//  SafeRide-Chicago
//

import Foundation
import MapKit

// MARK: - Reusable Coordinate

struct CoordinatePoint: Codable, Hashable {
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}

// MARK: - Accessible Area

struct AccessibleArea: Identifiable, Codable, Hashable {
    let id: UUID

    let name: String

    // Coordinates surrounding the outside of the area.
    let perimeterPoints: [CoordinatePoint]

    // Places where users can enter or exit.
    let entrancePoints: [CoordinatePoint]

    // Verified points located along internal walking paths.
    let surveyedPathPoints: [CoordinatePoint]

    // Score from 1 through 5.
    let lightingScore: Double

    let isWheelchairAccessible: Bool
    let pathCondition: SidewalkCondition
    let obstacles: [RouteObstacle]

    let notes: String

    init(
        id: UUID = UUID(),
        name: String,
        perimeterPoints: [CoordinatePoint],
        entrancePoints: [CoordinatePoint],
        surveyedPathPoints: [CoordinatePoint],
        lightingScore: Double,
        isWheelchairAccessible: Bool,
        pathCondition: SidewalkCondition,
        obstacles: [RouteObstacle] = [],
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.perimeterPoints = perimeterPoints
        self.entrancePoints = entrancePoints
        self.surveyedPathPoints = surveyedPathPoints
        self.lightingScore = lightingScore
        self.isWheelchairAccessible = isWheelchairAccessible
        self.pathCondition = pathCondition
        self.obstacles = obstacles
        self.notes = notes
    }

    var perimeterCoordinates: [CLLocationCoordinate2D] {
        perimeterPoints.map { point in
            point.coordinate
        }
    }

    var entranceCoordinates: [CLLocationCoordinate2D] {
        entrancePoints.map { point in
            point.coordinate
        }
    }

    var pathCoordinates: [CLLocationCoordinate2D] {
        surveyedPathPoints.map { point in
            point.coordinate
        }
    }

    func makePolygon() -> MKPolygon {
        var coordinates = perimeterCoordinates

        return MKPolygon(
            coordinates: &coordinates,
            count: coordinates.count
        )
    }
}

// MARK: - Arrigo Park Data

extension AccessibleArea {
    static let arrigoPark = AccessibleArea(
        name: "Arrigo Park",

        perimeterPoints: [
            CoordinatePoint(
                latitude: 41.871278,
                longitude: -87.661611
            ),
            CoordinatePoint(
                latitude: 41.871750,
                longitude: -87.661639
            ),
            CoordinatePoint(
                latitude: 41.872194,
                longitude: -87.661639
            ),
            CoordinatePoint(
                latitude: 41.872194,
                longitude: -87.658472
            ),
            CoordinatePoint(
                latitude: 41.871861,
                longitude: -87.658111
            ),
            CoordinatePoint(
                latitude: 41.871639,
                longitude: -87.658111
            ),
            CoordinatePoint(
                latitude: 41.871333,
                longitude: -87.658472
            )
        ],

        entrancePoints: [
            CoordinatePoint(
                latitude: 41.871278,
                longitude: -87.661611
            ),
            CoordinatePoint(
                latitude: 41.871750,
                longitude: -87.661639
            ),
            CoordinatePoint(
                latitude: 41.872194,
                longitude: -87.661639
            ),
            CoordinatePoint(
                latitude: 41.872194,
                longitude: -87.658472
            ),
            CoordinatePoint(
                latitude: 41.871861,
                longitude: -87.658111
            ),
            CoordinatePoint(
                latitude: 41.871639,
                longitude: -87.658111
            ),
            CoordinatePoint(
                latitude: 41.871333,
                longitude: -87.658472
            )
        ],

        surveyedPathPoints: [
            CoordinatePoint(
                latitude: 41.871500,
                longitude: -87.658472
            ),
            CoordinatePoint(
                latitude: 41.872056,
                longitude: -87.658472
            ),
            CoordinatePoint(
                latitude: 41.872028,
                longitude: -87.659278
            ),
            CoordinatePoint(
                latitude: 41.871583,
                longitude: -87.659333
            ),
            CoordinatePoint(
                latitude: 41.871972,
                longitude: -87.660167
            ),
            CoordinatePoint(
                latitude: 41.871528,
                longitude: -87.660167
            )
        ],

        lightingScore: 1.0,
        isWheelchairAccessible: true,
        pathCondition: .good,
        obstacles: [],

        notes: """
        Arrigo Park has multiple entrances and exits. The walking paths \
        are in good condition and suitable for wheelchair users. Nighttime \
        lighting is very poor and was rated 1 out of 5.
        """
    )

    static let demoAreas: [AccessibleArea] = [
        .arrigoPark
    ]
}
