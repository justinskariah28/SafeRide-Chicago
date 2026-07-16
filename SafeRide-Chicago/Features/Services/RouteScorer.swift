//
//  RouteScorer.swift
//  SafeRide-Chicago
//

import CoreLocation
import Foundation
import MapKit

// MARK: - Preference Names

enum RoutePreferenceName {
    static let wellLitStreets = "Well-lit streets"
    static let nearbySafeSpots = "Nearby Safe Spots"
    static let stepFreeRoute = "Step-free route"
    static let avoidCrowdedAreas = "Avoid crowded areas"
}

// MARK: - Route Analysis

struct RouteAnalysis {
    let matchedStreetSegments: [StreetSegment]
    let nearbySafeSpots: [SafeSpot]
    let traversedAccessibleAreas: [AccessibleArea]

    let averageLightingScore: Double?
    let wheelchairAccessibleRatio: Double
    let goodSidewalkRatio: Double
    let averageCrowdingScore: Double?

    let turnCount: Int
    let travelTimeMinutes: Double
    let distanceMeters: CLLocationDistance

    let usesTaylorStreet: Bool
    let usesHarrisonStreet: Bool
    let usesPolkStreet: Bool
    let usesRacineAvenue: Bool
    let usesCabriniStreet: Bool
    let usesLexingtonStreet: Bool
    let passesThroughArrigoPark: Bool
}

// MARK: - Scored Route

struct ScoredRoute {
    let route: MKRoute
    let score: Double
    let analysis: RouteAnalysis
    let reasons: [String]

    var roundedScore: Int {
        Int(score.rounded())
    }
}

// MARK: - Route Scorer

enum RouteScorer {

    private static let safeSpotDistance: CLLocationDistance = 75
    private static let arrigoPathDistance: CLLocationDistance = 25

    // MARK: - Analyze Route

    static func analyze(
        route: MKRoute,
        streetSegments: [StreetSegment] = StreetSegment.demoSegments,
        safeSpots: [SafeSpot] = SafeSpot.demoSafeSpots,
        accessibleAreas: [AccessibleArea] = AccessibleArea.demoAreas
    ) -> RouteAnalysis {

        let routeCoordinates = coordinates(
            from: route.polyline
        )

        /*
         Street matching is based primarily on MapKit step
         instructions.

         This prevents a route on Harrison from being incorrectly
         labeled as a Taylor Street route just because the two
         streets are geographically close.
         */

        let matchedSegments = streetSegments.filter { segment in
            routeUsesStreet(
                route: route,
                streetSegment: segment
            )
        }

        let nearbySpots = safeSpots.filter { safeSpot in
            routePassesNearCoordinate(
                routeCoordinates: routeCoordinates,
                coordinate: safeSpot.coordinate,
                maximumDistance: safeSpotDistance
            )
        }

        let traversedAreas = accessibleAreas.filter { area in
            routePassesThroughArea(
                routeCoordinates: routeCoordinates,
                area: area
            )
        }

        let averageLighting = calculateAverageLighting(
            streetSegments: matchedSegments,
            areas: traversedAreas
        )

        let wheelchairRatio =
            calculateWheelchairAccessibleRatio(
                streetSegments: matchedSegments,
                areas: traversedAreas
            )

        let sidewalkRatio =
            calculateGoodSidewalkRatio(
                streetSegments: matchedSegments,
                areas: traversedAreas
            )

        let crowdingScore =
            calculateAverageCrowdingScore(
                streetSegments: matchedSegments
            )

        let turnCount = usableStepCount(
            route
        )

        let usesTaylor = routeUsesStreetName(
            route: route,
            streetNames: [
                "Taylor",
                "W Taylor",
                "West Taylor"
            ]
        )

        let usesHarrison = routeUsesStreetName(
            route: route,
            streetNames: [
                "Harrison",
                "W Harrison",
                "West Harrison"
            ]
        )

        let usesPolk = routeUsesStreetName(
            route: route,
            streetNames: [
                "Polk",
                "W Polk",
                "West Polk"
            ]
        )

        let usesRacine = routeUsesStreetName(
            route: route,
            streetNames: [
                "Racine",
                "S Racine",
                "South Racine"
            ]
        )

        let usesCabrini = routeUsesStreetName(
            route: route,
            streetNames: [
                "Cabrini",
                "W Cabrini",
                "West Cabrini"
            ]
        )

        let usesLexington = routeUsesStreetName(
            route: route,
            streetNames: [
                "Lexington",
                "W Lexington",
                "West Lexington"
            ]
        )

        let passesThroughArrigo =
            traversedAreas.contains { area in
                area.name.localizedCaseInsensitiveContains(
                    "Arrigo"
                )
            }

        return RouteAnalysis(
            matchedStreetSegments: matchedSegments,
            nearbySafeSpots: nearbySpots,
            traversedAccessibleAreas: traversedAreas,
            averageLightingScore: averageLighting,
            wheelchairAccessibleRatio: wheelchairRatio,
            goodSidewalkRatio: sidewalkRatio,
            averageCrowdingScore: crowdingScore,
            turnCount: turnCount,
            travelTimeMinutes: route.expectedTravelTime / 60,
            distanceMeters: route.distance,
            usesTaylorStreet: usesTaylor,
            usesHarrisonStreet: usesHarrison,
            usesPolkStreet: usesPolk,
            usesRacineAvenue: usesRacine,
            usesCabriniStreet: usesCabrini,
            usesLexingtonStreet: usesLexington,
            passesThroughArrigoPark: passesThroughArrigo
        )
    }

    // MARK: - Score Route

    static func score(
        route: MKRoute,
        selectedPreferences: [String],
        streetSegments: [StreetSegment] = StreetSegment.demoSegments,
        safeSpots: [SafeSpot] = SafeSpot.demoSafeSpots,
        accessibleAreas: [AccessibleArea] = AccessibleArea.demoAreas
    ) -> ScoredRoute {

        let preferences = Set(
            selectedPreferences
        )

        let analysis = analyze(
            route: route,
            streetSegments: streetSegments,
            safeSpots: safeSpots,
            accessibleAreas: accessibleAreas
        )

        var score = 70.0
        var reasons: [String] = []

        // Small penalties for time and route complexity.
        score -= analysis.travelTimeMinutes * 0.8
        score -= Double(analysis.turnCount) * 0.4

        // MARK: Well-Lit Streets

        if preferences.contains(
            RoutePreferenceName.wellLitStreets
        ) {
            applyLightingScore(
                analysis: analysis,
                score: &score,
                reasons: &reasons
            )
        }

        // MARK: Nearby Safe Spots

        if preferences.contains(
            RoutePreferenceName.nearbySafeSpots
        ) {
            applySafeSpotScore(
                analysis: analysis,
                score: &score,
                reasons: &reasons
            )
        }

        // MARK: Step-Free Route

        if preferences.contains(
            RoutePreferenceName.stepFreeRoute
        ) {
            applyStepFreeScore(
                analysis: analysis,
                score: &score,
                reasons: &reasons
            )
        }

        // MARK: Avoid Crowded Areas

        if preferences.contains(
            RoutePreferenceName.avoidCrowdedAreas
        ) {
            applyCrowdingScore(
                analysis: analysis,
                score: &score,
                reasons: &reasons
            )
        }

        // MARK: Obstacles

        let obstacleCount =
            analysis.matchedStreetSegments.reduce(0) {
                partialResult,
                segment in

                partialResult + segment.obstacles.count
            }

        if obstacleCount > 0 {
            score -= Double(obstacleCount) * 20

            reasons.append(
                "Includes a street with a reported obstacle."
            )
        }

        if reasons.isEmpty {
            reasons.append(
                "Balances walking time and route simplicity."
            )
        }

        return ScoredRoute(
            route: route,
            score: score,
            analysis: analysis,
            reasons: removeDuplicateReasons(
                reasons
            )
        )
    }

    // MARK: - Recommended Route

    static func recommendedRoute(
        from routes: [MKRoute],
        selectedPreferences: [String],
        streetSegments: [StreetSegment] = StreetSegment.demoSegments,
        safeSpots: [SafeSpot] = SafeSpot.demoSafeSpots,
        accessibleAreas: [AccessibleArea] = AccessibleArea.demoAreas
    ) -> ScoredRoute? {

        let scoredRoutes = routes.map { route in
            score(
                route: route,
                selectedPreferences: selectedPreferences,
                streetSegments: streetSegments,
                safeSpots: safeSpots,
                accessibleAreas: accessibleAreas
            )
        }

        return scoredRoutes.max {
            first,
            second in

            first.score < second.score
        }
    }

    // MARK: - Fastest Route

    static func fastestRoute(
        from routes: [MKRoute]
    ) -> MKRoute? {

        routes.min {
            first,
            second in

            first.expectedTravelTime <
                second.expectedTravelTime
        }
    }

    // MARK: - Simplest Route

    static func simplestRoute(
        from routes: [MKRoute]
    ) -> MKRoute? {

        routes.min {
            first,
            second in

            usableStepCount(first) <
                usableStepCount(second)
        }
    }

    // MARK: - Lighting Scoring

    private static func applyLightingScore(
        analysis: RouteAnalysis,
        score: inout Double,
        reasons: inout [String]
    ) {

        /*
         Arrigo Park receives the strongest penalty because
         its verified lighting score is 1 out of 5.
         */

        if analysis.passesThroughArrigoPark {
            score -= 100

            reasons.append(
                "Passes through Arrigo Park, rated 1 out of 5 for lighting."
            )
        }

        /*
         Use the actual streets found in the MapKit directions.
         Only add a street description when the route genuinely
         uses that street.
         */

        if analysis.usesTaylorStreet {
            score += 65

            reasons.append(
                "Uses Taylor Street, rated 5 out of 5 for lighting."
            )
        }

        if analysis.usesHarrisonStreet {
            score += 35

            reasons.append(
                "Uses Harrison Street, rated 3.5 out of 5 for lighting."
            )
        }

        if analysis.usesPolkStreet {
            score += 35

            reasons.append(
                "Uses Polk Street, rated 3.5 out of 5 for lighting."
            )
        }

        if analysis.usesRacineAvenue {
            score += 25

            reasons.append(
                "Uses Racine Avenue, rated 3 out of 5 for lighting."
            )
        }

        if analysis.usesCabriniStreet {
            score += 5

            reasons.append(
                "Uses Cabrini Street, rated 2 out of 5 for lighting."
            )
        }

        if analysis.usesLexingtonStreet {
            score += 5

            reasons.append(
                "Uses Lexington Street, rated 2 out of 5 for lighting."
            )
        }

        /*
         Apply the average score from every verified street and
         park area matched to the route.
         */

        if let averageLighting =
            analysis.averageLightingScore {

            score += averageLighting * 8

            if averageLighting >= 4.5 {
                reasons.insert(
                    "Uses streets with excellent nighttime lighting.",
                    at: 0
                )
            } else if averageLighting >= 3.0 {
                reasons.insert(
                    "Uses streets with moderate nighttime lighting.",
                    at: 0
                )
            } else if averageLighting <= 2.0 {
                score -= 30

                reasons.insert(
                    "Includes an area with poor nighttime lighting.",
                    at: 0
                )
            }
        } else {
            score -= 10

            reasons.append(
                "Limited verified lighting information is available."
            )
        }
    }

    // MARK: - Safe Spot Scoring

    private static func applySafeSpotScore(
        analysis: RouteAnalysis,
        score: inout Double,
        reasons: inout [String]
    ) {

        guard !analysis.nearbySafeSpots.isEmpty else {
            score -= 5

            reasons.append(
                "No verified Safe Spots were found near this route."
            )

            return
        }

        let bonus = min(
            Double(analysis.nearbySafeSpots.count) * 18,
            54
        )

        score += bonus

        let names = analysis.nearbySafeSpots
            .prefix(2)
            .map(\.name)
            .joined(separator: " and ")

        reasons.append(
            "Passes near \(names)."
        )
    }

    // MARK: - Step-Free Scoring

    private static func applyStepFreeScore(
        analysis: RouteAnalysis,
        score: inout Double,
        reasons: inout [String]
    ) {

        score +=
            analysis.wheelchairAccessibleRatio * 40

        score +=
            analysis.goodSidewalkRatio * 20

        if analysis.wheelchairAccessibleRatio >= 0.8 {
            reasons.append(
                "Uses verified wheelchair-accessible streets and paths."
            )
        } else if analysis.wheelchairAccessibleRatio == 0 {
            score -= 20

            reasons.append(
                "Limited verified step-free information is available."
            )
        }

        let inaccessibleAreas =
            analysis.traversedAccessibleAreas.filter {
                !$0.isWheelchairAccessible
            }

        score -=
            Double(inaccessibleAreas.count) * 80
    }

    // MARK: - Crowding Scoring

    private static func applyCrowdingScore(
        analysis: RouteAnalysis,
        score: inout Double,
        reasons: inout [String]
    ) {

        guard let crowding =
                analysis.averageCrowdingScore else {

            score -= 5

            reasons.append(
                "Limited crowding information is available."
            )

            return
        }

        score += crowding * 35

        if crowding >= 0.8 {
            reasons.append(
                "Uses streets with low reported crowding."
            )
        } else if crowding <= 0.25 {
            score -= 25

            reasons.append(
                "Includes streets with high reported crowding."
            )
        }
    }

    // MARK: - Match Street Using Route Instructions

    private static func routeUsesStreet(
        route: MKRoute,
        streetSegment: StreetSegment
    ) -> Bool {

        let possibleNames =
            streetSearchNames(
                for: streetSegment.name
            )

        return routeUsesStreetName(
            route: route,
            streetNames: possibleNames
        )
    }

    private static func streetSearchNames(
        for streetName: String
    ) -> [String] {

        let normalized = streetName
            .replacingOccurrences(
                of: "Street",
                with: "",
                options: .caseInsensitive
            )
            .replacingOccurrences(
                of: "Avenue",
                with: "",
                options: .caseInsensitive
            )
            .replacingOccurrences(
                of: "Road",
                with: "",
                options: .caseInsensitive
            )
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        return [
            streetName,
            normalized
        ]
    }

    private static func routeUsesStreetName(
        route: MKRoute,
        streetNames: [String]
    ) -> Bool {

        let normalizedNames = streetNames
            .map {
                normalizeStreetText($0)
            }
            .filter {
                !$0.isEmpty
            }

        return route.steps.contains { step in
            let normalizedInstructions =
                normalizeStreetText(
                    step.instructions
                )

            return normalizedNames.contains { name in
                containsWholeStreetName(
                    instructions: normalizedInstructions,
                    streetName: name
                )
            }
        }
    }

    private static func normalizeStreetText(
        _ text: String
    ) -> String {

        text
            .lowercased()
            .replacingOccurrences(
                of: ".",
                with: ""
            )
            .replacingOccurrences(
                of: ",",
                with: " "
            )
            .replacingOccurrences(
                of: "-",
                with: " "
            )
            .replacingOccurrences(
                of: "street",
                with: "st"
            )
            .replacingOccurrences(
                of: "avenue",
                with: "ave"
            )
            .replacingOccurrences(
                of: "road",
                with: "rd"
            )
            .replacingOccurrences(
                of: "boulevard",
                with: "blvd"
            )
            .replacingOccurrences(
                of: "west",
                with: "w"
            )
            .replacingOccurrences(
                of: "east",
                with: "e"
            )
            .replacingOccurrences(
                of: "south",
                with: "s"
            )
            .replacingOccurrences(
                of: "north",
                with: "n"
            )
            .split(
                whereSeparator: \.isWhitespace
            )
            .joined(separator: " ")
    }

    private static func containsWholeStreetName(
        instructions: String,
        streetName: String
    ) -> Bool {

        let instructionWords =
            instructions.split(separator: " ")

        let streetWords =
            streetName.split(separator: " ")

        guard !streetWords.isEmpty else {
            return false
        }

        if streetWords.count == 1 {
            return instructionWords.contains(
                streetWords[0]
            )
        }

        return instructions.contains(
            streetName
        )
    }

    // MARK: - Safe Spot Matching

    private static func routePassesNearCoordinate(
        routeCoordinates: [CLLocationCoordinate2D],
        coordinate: CLLocationCoordinate2D,
        maximumDistance: CLLocationDistance
    ) -> Bool {

        let targetLocation = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )

        return routeCoordinates.contains {
            routeCoordinate in

            let routeLocation = CLLocation(
                latitude: routeCoordinate.latitude,
                longitude: routeCoordinate.longitude
            )

            return routeLocation.distance(
                from: targetLocation
            ) <= maximumDistance
        }
    }

    // MARK: - Accessible Area Matching

    private static func routePassesThroughArea(
        routeCoordinates: [CLLocationCoordinate2D],
        area: AccessibleArea
    ) -> Bool {

        for coordinate in routeCoordinates {
            if pointIsInsidePolygon(
                point: coordinate,
                polygon: area.perimeterCoordinates
            ) {
                return true
            }

            let routeLocation = CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )

            for pathCoordinate in area.pathCoordinates {
                let pathLocation = CLLocation(
                    latitude: pathCoordinate.latitude,
                    longitude: pathCoordinate.longitude
                )

                if routeLocation.distance(
                    from: pathLocation
                ) <= arrigoPathDistance {
                    return true
                }
            }
        }

        return false
    }

    // MARK: - Lighting Average

    private static func calculateAverageLighting(
        streetSegments: [StreetSegment],
        areas: [AccessibleArea]
    ) -> Double? {

        let streetScores = streetSegments.map {
            $0.lightingScore
        }

        let areaScores = areas.map {
            $0.lightingScore
        }

        let allScores =
            streetScores + areaScores

        guard !allScores.isEmpty else {
            return nil
        }

        return allScores.reduce(0, +) /
            Double(allScores.count)
    }

    // MARK: - Accessibility Ratio

    private static func calculateWheelchairAccessibleRatio(
        streetSegments: [StreetSegment],
        areas: [AccessibleArea]
    ) -> Double {

        let streetValues = streetSegments.map {
            $0.isWheelchairAccessible ? 1.0 : 0.0
        }

        let areaValues = areas.map {
            $0.isWheelchairAccessible ? 1.0 : 0.0
        }

        let values =
            streetValues + areaValues

        guard !values.isEmpty else {
            return 0
        }

        return values.reduce(0, +) /
            Double(values.count)
    }

    // MARK: - Sidewalk Ratio

    private static func calculateGoodSidewalkRatio(
        streetSegments: [StreetSegment],
        areas: [AccessibleArea]
    ) -> Double {

        let streetValues =
            streetSegments.map { segment in
                sidewalkQualityValue(
                    segment.sidewalkCondition
                )
            }

        let areaValues =
            areas.map { area in
                sidewalkQualityValue(
                    area.pathCondition
                )
            }

        let values =
            streetValues + areaValues

        guard !values.isEmpty else {
            return 0
        }

        return values.reduce(0, +) /
            Double(values.count)
    }

    private static func sidewalkQualityValue(
        _ condition: SidewalkCondition
    ) -> Double {

        switch condition {
        case .excellent:
            return 1.0

        case .good:
            return 0.85

        case .fair:
            return 0.45

        case .poor:
            return 0.0
        }
    }

    // MARK: - Crowding Average

    private static func calculateAverageCrowdingScore(
        streetSegments: [StreetSegment]
    ) -> Double? {

        guard !streetSegments.isEmpty else {
            return nil
        }

        let scores =
            streetSegments.map { segment in
                crowdingValue(
                    segment.crowding
                )
            }

        return scores.reduce(0, +) /
            Double(scores.count)
    }

    private static func crowdingValue(
        _ crowding: CrowdingLevel
    ) -> Double {

        switch crowding {
        case .low:
            return 1.0

        case .moderate:
            return 0.55

        case .high:
            return 0.0

        case .unknown:
            return 0.4
        }
    }

    // MARK: - Route Coordinates

    private static func coordinates(
        from polyline: MKPolyline
    ) -> [CLLocationCoordinate2D] {

        guard polyline.pointCount > 0 else {
            return []
        }

        let points =
            polyline.points()

        return (0..<polyline.pointCount).map {
            points[$0].coordinate
        }
    }

    // MARK: - Step Count

    private static func usableStepCount(
        _ route: MKRoute
    ) -> Int {

        route.steps.filter {
            !$0.instructions
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                .isEmpty
        }.count
    }

    // MARK: - Point in Polygon

    private static func pointIsInsidePolygon(
        point: CLLocationCoordinate2D,
        polygon: [CLLocationCoordinate2D]
    ) -> Bool {

        guard polygon.count >= 3 else {
            return false
        }

        var isInside = false
        var previousIndex =
            polygon.count - 1

        for currentIndex in polygon.indices {
            let currentPoint =
                polygon[currentIndex]

            let previousPoint =
                polygon[previousIndex]

            let longitudeCrosses =
                (currentPoint.longitude > point.longitude) !=
                (previousPoint.longitude > point.longitude)

            if longitudeCrosses {
                let latitudeAtCrossing =
                    (previousPoint.latitude -
                        currentPoint.latitude) *
                    (point.longitude -
                        currentPoint.longitude) /
                    (previousPoint.longitude -
                        currentPoint.longitude) +
                    currentPoint.latitude

                if point.latitude <
                    latitudeAtCrossing {

                    isInside.toggle()
                }
            }

            previousIndex =
                currentIndex
        }

        return isInside
    }

    // MARK: - Remove Duplicate Reasons

    private static func removeDuplicateReasons(
        _ reasons: [String]
    ) -> [String] {

        var seenReasons = Set<String>()

        return reasons.filter { reason in
            seenReasons.insert(reason).inserted
        }
    }
}
