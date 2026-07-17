//
//  ActiveRouteMapView.swift
//  SafeRide-Chicago
//

import MapKit
import SwiftUI

struct ActiveRouteMapView: UIViewRepresentable {
    let route: MKRoute
    let safeSpots: [SafeSpot]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()

        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.isRotateEnabled = true
        mapView.pointOfInterestFilter = .includingAll

        return mapView
    }

    func updateUIView(
        _ mapView: MKMapView,
        context: Context
    ) {
        configureRouteIfNeeded(
            on: mapView,
            coordinator: context.coordinator
        )

        updateSafeSpotAnnotations(
            on: mapView,
            coordinator: context.coordinator
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    private func configureRouteIfNeeded(
        on mapView: MKMapView,
        coordinator: Coordinator
    ) {
        guard !coordinator.hasConfiguredMap else {
            return
        }

        coordinator.hasConfiguredMap = true
        coordinator.routePolyline = route.polyline

        mapView.addOverlay(route.polyline)

        addDestinationAnnotation(to: mapView)

        mapView.setVisibleMapRect(
            route.polyline.boundingMapRect,
            edgePadding: UIEdgeInsets(
                top: 100,
                left: 50,
                bottom: 330,
                right: 50
            ),
            animated: false
        )

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1
        ) {
            mapView.setUserTrackingMode(
                .followWithHeading,
                animated: true
            )
        }
    }

    private func updateSafeSpotAnnotations(
        on mapView: MKMapView,
        coordinator: Coordinator
    ) {
        let newSafeSpotIDs = Set(safeSpots.map(\.id))

        guard newSafeSpotIDs !=
                coordinator.displayedSafeSpotIDs else {
            return
        }

        let oldSafeSpotAnnotations =
            mapView.annotations.compactMap {
                $0 as? SafeSpotAnnotation
            }

        mapView.removeAnnotations(
            oldSafeSpotAnnotations
        )

        let newAnnotations = safeSpots.map {
            SafeSpotAnnotation(safeSpot: $0)
        }

        mapView.addAnnotations(newAnnotations)

        coordinator.displayedSafeSpotIDs =
            newSafeSpotIDs
    }

    private func addDestinationAnnotation(
        to mapView: MKMapView
    ) {
        guard let destinationCoordinate =
                endingCoordinate(
                    for: route.polyline
                ) else {
            return
        }

        let annotation = DestinationAnnotation(
            coordinate: destinationCoordinate
        )

        mapView.addAnnotation(annotation)
    }

    private func endingCoordinate(
        for polyline: MKPolyline
    ) -> CLLocationCoordinate2D? {
        guard polyline.pointCount > 0 else {
            return nil
        }

        let points = polyline.points()

        return points[
            polyline.pointCount - 1
        ].coordinate
    }

    final class Coordinator:
        NSObject,
        MKMapViewDelegate
    {
        var hasConfiguredMap = false
        var routePolyline: MKPolyline?
        var displayedSafeSpotIDs: Set<UUID> = []

        func mapView(
            _ mapView: MKMapView,
            rendererFor overlay: MKOverlay
        ) -> MKOverlayRenderer {
            guard let polyline =
                    overlay as? MKPolyline else {
                return MKOverlayRenderer(
                    overlay: overlay
                )
            }

            let renderer =
                MKPolylineRenderer(polyline: polyline)

            renderer.strokeColor = UIColor(
                red: 71 / 255,
                green: 56 / 255,
                blue: 76 / 255,
                alpha: 1
            )

            renderer.lineWidth = 7
            renderer.lineCap = .round
            renderer.lineJoin = .round

            return renderer
        }

        func mapView(
            _ mapView: MKMapView,
            viewFor annotation: MKAnnotation
        ) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }

            if annotation is SafeSpotAnnotation {
                let identifier = "SafeSpot"

                let marker =
                    mapView.dequeueReusableAnnotationView(
                        withIdentifier: identifier
                    ) as? MKMarkerAnnotationView
                    ?? MKMarkerAnnotationView(
                        annotation: annotation,
                        reuseIdentifier: identifier
                    )

                marker.annotation = annotation
                marker.canShowCallout = true
                marker.markerTintColor = UIColor(
                    red: 71 / 255,
                    green: 56 / 255,
                    blue: 76 / 255,
                    alpha: 1
                )
                marker.glyphImage =
                    UIImage(systemName: "shield.fill")

                return marker
            }

            if annotation is DestinationAnnotation {
                let identifier = "Destination"

                let marker =
                    mapView.dequeueReusableAnnotationView(
                        withIdentifier: identifier
                    ) as? MKMarkerAnnotationView
                    ?? MKMarkerAnnotationView(
                        annotation: annotation,
                        reuseIdentifier: identifier
                    )

                marker.annotation = annotation
                marker.canShowCallout = true
                marker.markerTintColor = .black
                marker.glyphImage =
                    UIImage(systemName: "flag.checkered")

                return marker
            }

            return nil
        }
    }
}

// MARK: - Map Annotations

private final class SafeSpotAnnotation:
    NSObject,
    MKAnnotation
{
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?

    init(safeSpot: SafeSpot) {
        coordinate = safeSpot.coordinate
        title = safeSpot.name

        var features: [String] = []

        if safeSpot.isWheelchairAccessible {
            features.append("Wheelchair accessible")
        }

        if safeSpot.isWellLit {
            features.append("Well lit")
        }

        subtitle = features.joined(separator: " • ")
    }
}

private final class DestinationAnnotation:
    NSObject,
    MKAnnotation
{
    let coordinate: CLLocationCoordinate2D
    let title: String? = "Destination"

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
