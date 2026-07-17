//
//  ActiveNavigationView.swift
//  SafeRide-Chicago
//

import Combine
import CoreLocation
import MapKit
import SwiftUI

struct ActiveNavigationView: View {
    let route: MKRoute
    let destinationName: String

    @StateObject private var locationManager = LocationManager()

    @State private var currentStepIndex = 0
    @State private var hasArrived = false
    @State private var showingLocationError = false

    private var navigationSteps: [MKRoute.Step] {
        route.steps.filter {
            !$0.instructions
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
        }
    }

    private var currentStep: MKRoute.Step? {
        guard navigationSteps.indices.contains(currentStepIndex) else {
            return nil
        }

        return navigationSteps[currentStepIndex]
    }

    private var currentInstruction: String {
        if hasArrived {
            return "You have arrived at \(destinationName)"
        }

        return currentStep?.instructions ?? "Continue toward your destination"
    }

    private var remainingDistance: CLLocationDistance {
        guard !navigationSteps.isEmpty,
              navigationSteps.indices.contains(currentStepIndex) else {
            return route.distance
        }

        return navigationSteps[currentStepIndex...]
            .reduce(0) { partialResult, step in
                partialResult + step.distance
            }
    }

    private var navigationProgress: Double {
        guard !navigationSteps.isEmpty else {
            return 0
        }

        if hasArrived {
            return 1
        }

        return Double(currentStepIndex) /
            Double(navigationSteps.count)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ActiveRouteMapView(
                route: route,
                safeSpots: SafeSpot.demoSafeSpots
            )
            .ignoresSafeArea(edges: .bottom)

            navigationCard
        }
        /*
         The ZStack itself must extend to the physical bottom of the
         screen. This moves the navigation card below the bottom safe
         area instead of leaving an empty strip beneath it.
         */
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Navigation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color.safeRoutePurple)
                }
                .accessibilityLabel("Settings")
            }

            #if DEBUG
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    advanceToNextStep()
                } label: {
                    Image(systemName: "forward.fill")
                }
                .accessibilityLabel("Demonstrate next direction")
            }
            #endif
        }
        .onAppear {
            locationManager.startNavigationUpdates()
        }
        .onDisappear {
            locationManager.stopNavigationUpdates()
        }
        .onReceive(
            locationManager.$currentLocation.compactMap { $0 }
        ) { location in
            updateNavigation(using: location)
        }
        .onChange(of: locationManager.locationError) { error in
            if error != nil {
                showingLocationError = true
            }
        }
        .alert(
            "Location Unavailable",
            isPresented: $showingLocationError
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(
                locationManager.locationError ??
                "SafeRide could not determine your location."
            )
        }
    }

    private var navigationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Capsule()
                .fill(Color.secondary.opacity(0.35))
                .frame(width: 42, height: 5)
                .frame(maxWidth: .infinity)

            HStack(alignment: .top, spacing: 14) {
                Image(
                    systemName: hasArrived
                        ? "checkmark.circle.fill"
                        : navigationSymbol
                )
                .font(.system(size: 34))
                .foregroundStyle(Color.safeRoutePurple)
                .frame(width: 48)

                VStack(alignment: .leading, spacing: 6) {
                    Text(currentInstruction)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.safeRoutePurple)

                    if !hasArrived {
                        Text(distanceToCurrentStepText)
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            ProgressView(value: navigationProgress)
                .tint(Color.safeRoutePurple)

            HStack {
                navigationDetail(
                    title: "Remaining",
                    value: distanceText(remainingDistance),
                    systemImage: "figure.walk"
                )

                Spacer()

                navigationDetail(
                    title: "Estimated",
                    value: travelTimeText(route.expectedTravelTime),
                    systemImage: "clock"
                )

                Spacer()

                navigationDetail(
                    title: "Step",
                    value: stepNumberText,
                    systemImage: "list.number"
                )
            }

            if hasArrived {
                NavigationLink {
                    TripFeedback()
                } label: {
                    Text("Finish Trip")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .foregroundStyle(.white)
                        .background(Color.safeRoutePurple)
                        .clipShape(Capsule())
                }
            } else {
                HStack(spacing: 12) {
                    NavigationLink {
                        ReportFormView()
                    } label: {
                        Label(
                            "Report",
                            systemImage: "exclamationmark.bubble"
                        )
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundStyle(Color.safeRoutePurple)
                        .background(
                            Color.safeRoutePurple.opacity(0.10)
                        )
                        .clipShape(Capsule())
                    }

                    NavigationLink {
                        TripFeedback()
                    } label: {
                        Text("End Trip")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundStyle(.white)
                            .background(Color.safeRoutePurple)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 24)
        .background(.ultraThinMaterial)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 26,
                topTrailingRadius: 26
            )
        )
        .shadow(radius: 10)
    }

    private func navigationDetail(
        title: String,
        value: String,
        systemImage: String
    ) -> some View {
        VStack(spacing: 5) {
            Image(systemName: systemImage)
                .foregroundStyle(Color.safeRoutePurple)

            Text(value)
                .font(.system(size: 15, weight: .semibold))

            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
    }

    private var stepNumberText: String {
        guard !navigationSteps.isEmpty else {
            return "1 of 1"
        }

        return "\(min(currentStepIndex + 1, navigationSteps.count)) of \(navigationSteps.count)"
    }

    private var distanceToCurrentStepText: String {
        guard let currentStep else {
            return distanceText(remainingDistance)
        }

        guard let currentLocation = locationManager.currentLocation,
              let endpoint = endingCoordinate(
                for: currentStep.polyline
              ) else {
            return distanceText(currentStep.distance)
        }

        let endpointLocation = CLLocation(
            latitude: endpoint.latitude,
            longitude: endpoint.longitude
        )

        return distanceText(
            currentLocation.distance(from: endpointLocation)
        )
    }

    private var navigationSymbol: String {
        let lowercasedInstruction =
            currentInstruction.lowercased()

        if lowercasedInstruction.contains("left") {
            return "arrow.turn.up.left"
        }

        if lowercasedInstruction.contains("right") {
            return "arrow.turn.up.right"
        }

        if lowercasedInstruction.contains("arrive") {
            return "mappin.circle.fill"
        }

        if lowercasedInstruction.contains("continue") {
            return "arrow.up"
        }

        return "location.north.fill"
    }

    private func updateNavigation(
        using location: CLLocation
    ) {
        guard !hasArrived,
              let currentStep,
              let endpoint = endingCoordinate(
                for: currentStep.polyline
              ) else {
            return
        }

        let endpointLocation = CLLocation(
            latitude: endpoint.latitude,
            longitude: endpoint.longitude
        )

        let distanceFromStepEnd =
            location.distance(from: endpointLocation)

        if distanceFromStepEnd <= 25 {
            advanceToNextStep()
        }
    }

    private func advanceToNextStep() {
        guard !navigationSteps.isEmpty else {
            hasArrived = true
            return
        }

        if currentStepIndex < navigationSteps.count - 1 {
            currentStepIndex += 1
        } else {
            hasArrived = true
        }
    }

    private func endingCoordinate(
        for polyline: MKPolyline
    ) -> CLLocationCoordinate2D? {
        guard polyline.pointCount > 0 else {
            return nil
        }

        let points = polyline.points()

        return points[polyline.pointCount - 1].coordinate
    }

    private func distanceText(
        _ meters: CLLocationDistance
    ) -> String {
        let feet = meters * 3.28084

        if feet < 1_000 {
            return "\(max(Int(feet.rounded()), 1)) ft"
        }

        let miles = meters / 1_609.344

        return String(format: "%.1f mi", miles)
    }

    private func travelTimeText(
        _ seconds: TimeInterval
    ) -> String {
        let minutes = max(Int(seconds / 60), 1)
        return "\(minutes) min"
    }
}
