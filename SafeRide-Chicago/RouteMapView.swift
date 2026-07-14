//
//  RouteMapView.swift
//  SafeRide-Chicago
//
//  Created by 6 BGCC Loan Library on 7/8/26.
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

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)

        for route in allRoutes {
            mapView.addOverlay(route.polyline)
        }

        if let selectedRoute {
            mapView.addOverlay(selectedRoute.polyline)
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
            mapView.setRegion(UICServiceArea.region, animated: true)
        }

        context.coordinator.selectedPolyline = selectedRoute?.polyline
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var selectedPolyline: MKPolyline?

        func mapView(
            _ mapView: MKMapView,
            rendererFor overlay: MKOverlay
        ) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer(overlay: overlay)
            }

            let renderer = MKPolylineRenderer(polyline: polyline)

            if polyline === selectedPolyline {
                renderer.strokeColor = UIColor(
                    red: 71 / 255,
                    green: 56 / 255,
                    blue: 76 / 255,
                    alpha: 1.0
                )
                renderer.lineWidth = 7
            } else {
                renderer.strokeColor = UIColor.systemGray3
                renderer.lineWidth = 4
            }

            renderer.lineCap = .round
            renderer.lineJoin = .round

            return renderer
        }
    }
}
