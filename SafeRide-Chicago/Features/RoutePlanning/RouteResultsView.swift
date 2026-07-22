//
//  RouteResultsView.swift
//  SafeRide-Chicago
//
//  Created by 6 BGCC Loan Library on 7/8/26.
//

import SwiftUI
import MapKit

struct RouteResultsView: View {
    private static let ratingPredictor =
        RouteRatingPredictorManager()

    let startingLocation: String
    let destination: String
    let travelMode: TravelMode
    let selectedPreferences: [String]

    @State private var routeOptions: [RouteOption] = []
    @State private var selectedOption: RouteOption?
    @State private var isLoading = true
    @State private var errorMessage = ""

    @State private var isRoutePanelExpanded = false
    @GestureState private var routePanelDragOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                loadingView
            } else if !errorMessage.isEmpty {
                errorView
            } else {
                resultsView
            }
        }
        .background(Color.white)
        .navigationTitle("Route Options")
        .navigationBarTitleDisplayMode(.inline)
        .settingsToolbar()
        .task {
            await loadRoutes()
        }
    }

    // MARK: - Loading View

    private var loadingView: some View {
        VStack(spacing: 24) {
            Spacer()

            ProgressView()
                .controlSize(.large)
                .tint(Color.safeRoutePurple)

            Text("Finding accessible routes")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.safeRoutePurple)

            Text(
                "Comparing possible paths based on your travel mode and preferences."
            )
            .font(.system(size: 17))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)

            Spacer()
        }
    }

    // MARK: - Error View

    private var errorView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(
                systemName: "exclamationmark.triangle.fill"
            )
            .font(.system(size: 44))
            .foregroundStyle(Color.safeRoutePurple)

            Text("Could not find routes")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.safeRoutePurple)

            Text(errorMessage)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)

            Button {
                Task {
                    await loadRoutes()
                }
            } label: {
                Text("Try Again")
                    .font(
                        .system(
                            size: 17,
                            weight: .semibold
                        )
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .foregroundStyle(.white)
                    .background(Color.safeRoutePurple)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 28)

            Spacer()
        }
    }

    // MARK: - Results View

    private var resultsView: some View {
        GeometryReader { geometry in
            let collapsedHeight = min(
                max(geometry.size.height * 0.48, 360),
                430
            )

            let expandedHeight = max(
                geometry.size.height - 8,
                collapsedHeight
            )

            let restingHeight =
                isRoutePanelExpanded
                ? expandedHeight
                : collapsedHeight

            let draggedHeight =
                restingHeight - routePanelDragOffset

            let panelHeight = min(
                max(draggedHeight, collapsedHeight),
                expandedHeight
            )

            ZStack(alignment: .bottom) {
                RouteMapView(
                    selectedRoute: selectedOption?.route,
                    allRoutes: routeOptions.map {
                        $0.route
                    }
                )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )

                routePanel(
                    height: panelHeight
                )
            }
        }
    }

    private func routePanel(
        height: CGFloat
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            routePanelHandle

            Text("Choose your route")
                .font(
                    .system(
                        size: 26,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    Color.safeRoutePurple
                )

            Text(
                "\(startingLocation) → \(destination)"
            )
            .font(.system(size: 15))
            .foregroundStyle(.secondary)
            .lineLimit(2)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(routeOptions) { option in
                        RouteOptionCard(
                            option: option,
                            isSelected:
                                selectedOption?.id ==
                                option.id
                        ) {
                            selectedOption = option
                        }
                    }
                }
                .padding(.bottom, 8)
            }
            .scrollIndicators(.visible)

            routeStartButton
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .frame(
            height: height,
            alignment: .top
        )
        .background(Color.white)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 26,
                topTrailingRadius: 26
            )
        )
        .shadow(
            color: Color.black.opacity(0.18),
            radius: 12,
            y: -3
        )
        .animation(
            .spring(
                response: 0.38,
                dampingFraction: 0.86
            ),
            value: isRoutePanelExpanded
        )
    }

    private var routePanelHandle: some View {
        VStack(spacing: 7) {
            Capsule()
                .fill(
                    Color.secondary.opacity(0.40)
                )
                .frame(
                    width: 48,
                    height: 6
                )

            Image(
                systemName:
                    isRoutePanelExpanded
                    ? "chevron.down"
                    : "chevron.up"
            )
            .font(
                .system(
                    size: 12,
                    weight: .bold
                )
            )
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
        .padding(.bottom, 2)
        .contentShape(Rectangle())
        .gesture(routePanelDragGesture)
        .onTapGesture {
            withAnimation(
                .spring(
                    response: 0.38,
                    dampingFraction: 0.86
                )
            ) {
                isRoutePanelExpanded.toggle()
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Route options panel")
        .accessibilityHint(
            isRoutePanelExpanded
            ? "Swipe down or double tap to collapse."
            : "Swipe up or double tap to expand."
        )
        .accessibilityAction {
            isRoutePanelExpanded.toggle()
        }
    }

    private var routePanelDragGesture: some Gesture {
        DragGesture(minimumDistance: 5)
            .updating(
                $routePanelDragOffset
            ) { value, state, _ in
                state = value.translation.height
            }
            .onEnded { value in
                let movement =
                    value.predictedEndTranslation.height

                withAnimation(
                    .spring(
                        response: 0.38,
                        dampingFraction: 0.86
                    )
                ) {
                    if movement < -50 {
                        isRoutePanelExpanded = true
                    } else if movement > 50 {
                        isRoutePanelExpanded = false
                    }
                }
            }
    }

    @ViewBuilder
    private var routeStartButton: some View {
        if let selectedOption {
            NavigationLink {
                ActiveNavigationView(
                    route: selectedOption.route,
                    destinationName: destination
                )
            } label: {
                Text(
                    "Start \(selectedOption.title) Route"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .foregroundStyle(.white)
                .background(
                    Color.safeRoutePurple
                )
                .clipShape(Capsule())
            }
        } else {
            Text("Select a Route")
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .foregroundStyle(.white)
                .background(
                    Color.gray.opacity(0.45)
                )
                .clipShape(Capsule())
        }
    }

    // MARK: - Load Routes

    @MainActor
    private func loadRoutes() async {
        isLoading = true
        errorMessage = ""
        routeOptions = []
        selectedOption = nil

        do {
            let sourceMapItem =
                try await resolveSource()

            let destinationMapItem =
                try await resolveDestination()

            let request =
                MKDirections.Request()

            request.source =
                sourceMapItem

            request.destination =
                destinationMapItem

            request.transportType =
                mapKitTransportType

            request.requestsAlternateRoutes =
                true

            let directions =
                MKDirections(
                    request: request
                )

            let response =
                try await directions.calculate()

            let routes =
                response.routes

            guard !routes.isEmpty else {
                errorMessage =
                    "No route options were returned for this trip."

                isLoading = false
                return
            }

            let builtOptions =
                makeRouteOptions(
                    from: routes
                )

            guard !builtOptions.isEmpty else {
                errorMessage =
                    "SafeRide could not analyze the available routes."

                isLoading = false
                return
            }

            routeOptions =
                builtOptions

            selectedOption =
                builtOptions.first

            isLoading = false

        } catch {
            errorMessage =
                error.localizedDescription

            isLoading = false
        }
    }

    // MARK: - Resolve Starting Location

    private func resolveSource() async throws -> MKMapItem {
        if startingLocation
            .lowercased()
            .contains("current") {

            return MKMapItem(
                placemark: MKPlacemark(
                    coordinate:
                        CLLocationCoordinate2D(
                            latitude: 41.8703,
                            longitude: -87.6472
                        )
                )
            )
        }

        return try await searchMapItem(
            for: startingLocation
        )
    }

    // MARK: - Resolve Destination

    private func resolveDestination() async throws -> MKMapItem {
        if isStudentRecreationFacility(
            destination
        ) {
            return studentRecreationFacilityMapItem
        }

        return try await searchMapItem(
            for: destination
        )
    }

    // MARK: - Recreation Facility

    private func isStudentRecreationFacility(
        _ location: String
    ) -> Bool {

        let normalized =
            location.lowercased()

        if normalized.contains(
            "student recreation facility"
        ) {
            return true
        }

        if normalized.contains(
            "uic recreation"
        ) {
            return true
        }

        if normalized.contains("737") &&
            normalized.contains("halsted") {

            return true
        }

        return false
    }

    private var studentRecreationFacilityMapItem: MKMapItem {
        let coordinate =
            CLLocationCoordinate2D(
                latitude: 41.872454,
                longitude: -87.646303
            )

        let mapItem =
            MKMapItem(
                placemark: MKPlacemark(
                    coordinate: coordinate
                )
            )

        mapItem.name =
            "UIC Student Recreation Facility"

        return mapItem
    }

    // MARK: - Search Map Item

    private func searchMapItem(
        for query: String
    ) async throws -> MKMapItem {

        let request =
            MKLocalSearch.Request()

        request.naturalLanguageQuery =
            "\(query), Chicago, IL"

        request.region =
            UICServiceArea.region

        request.resultTypes = [
            .address,
            .pointOfInterest
        ]

        let search =
            MKLocalSearch(
                request: request
            )

        let response =
            try await search.start()

        guard !response.mapItems.isEmpty else {
            throw RouteResultsError.locationNotFound(
                query
            )
        }

        let serviceAreaCenter =
            CLLocation(
                latitude:
                    UICServiceArea.region.center.latitude,
                longitude:
                    UICServiceArea.region.center.longitude
            )

        let sortedItems =
            response.mapItems.sorted {
                first,
                second in

                distance(
                    from: first,
                    to: serviceAreaCenter
                ) <
                distance(
                    from: second,
                    to: serviceAreaCenter
                )
            }

        guard let closestItem =
                sortedItems.first else {

            throw RouteResultsError.locationNotFound(
                query
            )
        }

        let distanceFromUIC =
            distance(
                from: closestItem,
                to: serviceAreaCenter
            )

        guard distanceFromUIC <= 8_000 else {
            throw RouteResultsError
                .locationOutsideServiceArea(
                    query
                )
        }

        return closestItem
    }

    private func distance(
        from mapItem: MKMapItem,
        to location: CLLocation
    ) -> CLLocationDistance {

        let coordinate =
            mapItem.placemark.coordinate

        let mapItemLocation =
            CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )

        return mapItemLocation.distance(
            from: location
        )
    }

    // MARK: - Transportation Type

    private var mapKitTransportType:
        MKDirectionsTransportType {

        switch travelMode {
        case .walking:
            return .walking

        case .transit:
            return .transit

        case .driving:
            return .automobile
        }
    }

    // MARK: - Build Route Options

    private func makeRouteOptions(
        from routes: [MKRoute]
    ) -> [RouteOption] {

        guard !routes.isEmpty else {
            return []
        }

        guard let recommendedResult =
                RouteScorer.recommendedRoute(
                    from: routes,
                    selectedPreferences:
                        selectedPreferences
                ),
              let fastestRoute =
                RouteScorer.fastestRoute(
                    from: routes
                ),
              let simplestRoute =
                RouteScorer.simplestRoute(
                    from: routes
                ) else {

            return []
        }

        let fastestResult =
            RouteScorer.score(
                route: fastestRoute,
                selectedPreferences:
                    selectedPreferences
            )

        let simplestResult =
            RouteScorer.score(
                route: simplestRoute,
                selectedPreferences:
                    selectedPreferences
            )

        let recommendedReason =
            recommendedResult.reasons
                .prefix(2)
                .joined(separator: " ")

        let fastestReason =
            makeFastestReason(
                from: fastestResult
            )

        let simplestReason =
            makeSimplestReason(
                from: simplestResult
            )

        let recommendedRating =
            predictedRating(
                for: recommendedResult
            )

        let fastestRating =
            predictedRating(
                for: fastestResult
            )

        let simplestRating =
            predictedRating(
                for: simplestResult
            )

        return [
            RouteOption(
                type: .recommended,
                route: recommendedResult.route,
                accessibilityScore:
                    displayScore(
                        recommendedResult.score
                    ),
                predictedRating:
                    recommendedRating,
                reason:
                    recommendedReason.isEmpty
                    ? "Best match for your selected accessibility preferences."
                    : recommendedReason
            ),

            RouteOption(
                type: .fastest,
                route: fastestRoute,
                accessibilityScore:
                    displayScore(
                        fastestResult.score
                    ),
                predictedRating:
                    fastestRating,
                reason: fastestReason
            ),

            RouteOption(
                type: .simplest,
                route: simplestRoute,
                accessibilityScore:
                    displayScore(
                        simplestResult.score
                    ),
                predictedRating:
                    simplestRating,
                reason: simplestReason
            )
        ]
    }

    // MARK: - ML Rating

    private func predictedRating(
        for result: ScoredRoute
    ) -> Double? {
        guard let predictor =
                Self.ratingPredictor else {
            return nil
        }

        let preferences =
            Set(selectedPreferences)

        let obstacleCount =
            result.analysis
                .matchedStreetSegments
                .reduce(0) {
                    partialResult,
                    segment in

                    partialResult +
                        segment.obstacles.count
                }
            +
            result.analysis
                .traversedAccessibleAreas
                .reduce(0) {
                    partialResult,
                    area in

                    partialResult +
                        area.obstacles.count
                }

        return predictor.predictRating(
            prefStepFree:
                preferences.contains(
                    RoutePreferenceName
                        .stepFreeRoute
                ),

            prefFewerCrossings:
                prefersFewerCrossings,

            prefWellLit:
                preferences.contains(
                    RoutePreferenceName
                        .wellLitStreets
                ),

            prefSafeSpots:
                preferences.contains(
                    RoutePreferenceName
                        .nearbySafeSpots
                ),

            prefAvoidCrowds:
                preferences.contains(
                    RoutePreferenceName
                        .avoidCrowdedAreas
                ),

            routeAccessibility:
                result.analysis
                    .wheelchairAccessibleRatio,

            routeSidewalkQuality:
                result.analysis
                    .goodSidewalkRatio,

            routeLighting:
                result.analysis
                    .averageLightingScore
                ?? 0.0,

            routeSafeSpots:
                result.analysis
                    .nearbySafeSpots.count,

            routeCrowding:
                result.analysis
                    .averageCrowdingScore
                ?? 0.4,

            obstacleCount:
                obstacleCount,

            travelTime:
                result.analysis
                    .travelTimeMinutes,

            turnCount:
                result.analysis
                    .turnCount,

            distanceMeters:
                result.analysis
                    .distanceMeters
        )
    }

    private var prefersFewerCrossings: Bool {
        selectedPreferences.contains {
            preference in

            let normalized =
                preference.lowercased()

            return normalized.contains(
                "fewer crossing"
            )
            ||
            normalized.contains(
                "simple"
            )
        }
    }

    // MARK: - Card Reasons

    private func makeFastestReason(
        from result: ScoredRoute
    ) -> String {

        let accessibilityReason =
            result.reasons.first ?? ""

        if accessibilityReason.isEmpty {
            return """
            Gets you there in the least amount of time.
            """
        }

        return """
        Gets you there in the least amount of time. \(accessibilityReason)
        """
    }

    private func makeSimplestReason(
        from result: ScoredRoute
    ) -> String {

        let accessibilityReason =
            result.reasons.first ?? ""

        if accessibilityReason.isEmpty {
            return """
            Uses fewer turns and simpler directions.
            """
        }

        return """
        Uses fewer turns and simpler directions. \(accessibilityReason)
        """
    }

    // MARK: - Display Score

    private func displayScore(
        _ score: Double
    ) -> Int {

        let roundedScore =
            Int(score.rounded())

        return min(
            max(roundedScore, 0),
            100
        )
    }
}

// MARK: - Route Errors

enum RouteResultsError: LocalizedError {
    case locationNotFound(String)
    case locationOutsideServiceArea(String)

    var errorDescription: String? {
        switch self {
        case .locationNotFound(let query):
            return """
            Could not find a location for “\(query)” near UIC.
            """

        case .locationOutsideServiceArea(let query):
            return """
            The result for “\(query)” was outside SafeRide’s current UIC service area.
            """
        }
    }
}
