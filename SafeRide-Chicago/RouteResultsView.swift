//
//  RouteResultsView.swift
//  SafeRide-Chicago
//
//  Created by 6 BGCC Loan Library on 7/8/26.
//

import SwiftUI
import MapKit

struct RouteResultsView: View {
    let startingLocation: String
    let destination: String
    let travelMode: TravelMode
    let selectedPreferences: [String]

    @State private var routeOptions: [RouteOption] = []
    @State private var selectedOption: RouteOption?
    @State private var isLoading = true
    @State private var errorMessage = ""

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
        .task {
            await loadRoutes()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 24) {
            Spacer()

            ProgressView()
                .controlSize(.large)
                .tint(Color.safeRoutePurple)

            Text("Finding accessible routes")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.safeRoutePurple)

            Text("Comparing possible paths based on your travel mode and preferences.")
                .font(.system(size: 17))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
    }

    private var errorView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "exclamationmark.triangle.fill")
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
                    .font(.system(size: 17, weight: .semibold))
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

    private var resultsView: some View {
        VStack(spacing: 0) {
            RouteMapView(
                selectedRoute: selectedOption?.route,
                allRoutes: routeOptions.map { $0.route }
            )
            .frame(height: 330)

            VStack(alignment: .leading, spacing: 14) {
                Text("Choose your route")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Color.safeRoutePurple)

                Text("\(startingLocation) → \(destination)")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(routeOptions) { option in
                            RouteOptionCard(
                                option: option,
                                isSelected: selectedOption?.id == option.id
                            ) {
                                selectedOption = option
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }

                Button {
                    // Later this goes to active navigation.
                } label: {
                    Text("Start \(selectedOption?.title ?? "Route")")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundStyle(.white)
                        .background(Color.safeRoutePurple)
                        .clipShape(Capsule())
                }
            }
            .padding(20)
            .background(Color.white)
        }
    }

    private func loadRoutes() async {
        isLoading = true
        errorMessage = ""

        do {
            let sourceMapItem = try await resolveSource()
            let destinationMapItem = try await resolveDestination()

            let request = MKDirections.Request()
            request.source = sourceMapItem
            request.destination = destinationMapItem
            request.transportType = mapKitTransportType
            request.requestsAlternateRoutes = true

            let directions = MKDirections(request: request)
            let response = try await directions.calculate()

            let routes = response.routes

            if routes.isEmpty {
                errorMessage = "No route options were returned for this trip."
                isLoading = false
                return
            }

            let builtOptions = makeRouteOptions(from: routes)
            routeOptions = builtOptions
            selectedOption = builtOptions.first
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func resolveSource() async throws -> MKMapItem {
        // Prototype shortcut:
        // If user leaves "Current Location", we use Kaplan Institute as a UIC-area starting point.
        if startingLocation.lowercased().contains("current") {
            return MKMapItem(
                placemark: MKPlacemark(
                    coordinate: CLLocationCoordinate2D(
                        latitude: 41.8703,
                        longitude: -87.6472
                    )
                )
            )
        }

        return try await searchMapItem(for: startingLocation)
    }

    private func resolveDestination() async throws -> MKMapItem {
        return try await searchMapItem(for: destination)
    }

    private func searchMapItem(for query: String) async throws -> MKMapItem {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "\(query), Chicago, IL"
        request.region = UICServiceArea.region

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        if let item = response.mapItems.first {
            return item
        }

        throw RouteResultsError.locationNotFound(query)
    }

    private var mapKitTransportType: MKDirectionsTransportType {
        switch travelMode {
        case .walking:
            return .walking
        case .transit:
            return .transit
        case .driving:
            return .automobile
        }
    }

    private func makeRouteOptions(from routes: [MKRoute]) -> [RouteOption] {
        let sortedByTime = routes.sorted {
            $0.expectedTravelTime < $1.expectedTravelTime
        }

        let sortedBySteps = routes.sorted {
            routeStepCount($0) < routeStepCount($1)
        }

        let fastestRoute = sortedByTime[0]
        let simplestRoute = sortedBySteps[0]

        // Prototype "recommended" logic:
        // Prefer a route with fewer steps, but still close to the fastest time.
        let recommendedRoute = routes.max { first, second in
            prototypeAccessibilityScore(for: first) <
            prototypeAccessibilityScore(for: second)
        } ?? fastestRoute

        var options: [RouteOption] = [
            RouteOption(
                type: .recommended,
                route: recommendedRoute,
                accessibilityScore: prototypeAccessibilityScore(for: recommendedRoute),
                reason: recommendedReason()
            ),
            RouteOption(
                type: .fastest,
                route: fastestRoute,
                accessibilityScore: max(65, prototypeAccessibilityScore(for: fastestRoute) - 10),
                reason: "Gets you there in the least amount of time."
            ),
            RouteOption(
                type: .simplest,
                route: simplestRoute,
                accessibilityScore: max(70, prototypeAccessibilityScore(for: simplestRoute) - 4),
                reason: "Uses fewer turns and simpler directions."
            )
        ]

        // If MapKit returns the same route for multiple categories, still keep all 3 cards.
        // That is fine for the prototype.
        options.sort { first, second in
            RouteOptionType.allCases.firstIndex(of: first.type)! <
            RouteOptionType.allCases.firstIndex(of: second.type)!
        }

        return options
    }

    private func routeStepCount(_ route: MKRoute) -> Int {
        route.steps.filter { !$0.instructions.isEmpty }.count
    }

    private func prototypeAccessibilityScore(for route: MKRoute) -> Int {
        let stepPenalty = min(routeStepCount(route) * 2, 18)
        let timePenalty = min(Int(route.expectedTravelTime / 60) / 2, 15)
        let preferenceBoost = min(selectedPreferences.count * 3, 15)

        let score = 88 - stepPenalty - timePenalty + preferenceBoost
        return min(max(score, 55), 98)
    }

    private func recommendedReason() -> String {
        if selectedPreferences.isEmpty {
            return "Balances travel time, simplicity, and safer route conditions."
        }

        let topPreferences = selectedPreferences.prefix(2).joined(separator: " and ")

        return "Best match for \(topPreferences), while keeping the route practical."
    }
}

enum RouteResultsError: LocalizedError {
    case locationNotFound(String)

    var errorDescription: String? {
        switch self {
        case .locationNotFound(let query):
            return "Could not find a location for “\(query)” near UIC."
        }
    }
}
