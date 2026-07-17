//
//  RouteMapView.swift
//  SafeRide-Chicago
//

import SwiftUI
import MapKit

struct RouteMapView: UIViewRepresentable {
    let selectedRoute: MKRoute?
    let allRoutes: [MKRoute]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()

        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        mapView.isRotateEnabled = false
        mapView.pointOfInterestFilter = .includingAll

        return mapView
    }

    func updateUIView(
        _ mapView: MKMapView,
        context: Context
    ) {
        context.coordinator.selectedPolyline =
            selectedRoute?.polyline

        mapView.removeOverlays(mapView.overlays)

        var addedPolylines = Set<ObjectIdentifier>()

        for route in allRoutes {
            let polyline = route.polyline

            if let selectedPolyline =
                    selectedRoute?.polyline,
               polyline === selectedPolyline {
                continue
            }

            let identifier = ObjectIdentifier(polyline)

            if addedPolylines.insert(identifier).inserted {
                mapView.addOverlay(
                    polyline,
                    level: .aboveRoads
                )
            }
        }

        if let selectedRoute {
            mapView.addOverlay(
                selectedRoute.polyline,
                level: .aboveRoads
            )

            mapView.setVisibleMapRect(
                selectedRoute.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(
                    top: 60,
                    left: 40,
                    bottom: 60,
                    right: 40
                ),
                animated: true
            )
        } else {
            mapView.setRegion(
                UICServiceArea.region,
                animated: true
            )
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator:
        NSObject,
        MKMapViewDelegate
    {
        var selectedPolyline: MKPolyline?

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

            if polyline === selectedPolyline {
                renderer.strokeColor = UIColor(
                    red: 71 / 255,
                    green: 56 / 255,
                    blue: 76 / 255,
                    alpha: 1
                )
                renderer.lineWidth = 7
            } else {
                renderer.strokeColor = .systemGray3
                renderer.lineWidth = 4
            }

            renderer.lineCap = .round
            renderer.lineJoin = .round

            return renderer
        }
    }
}
