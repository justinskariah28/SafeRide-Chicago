//
//  RouteOption.swift
//  SafeRide-Chicago
//
//  Created by 6 BGCC Loan Library on 7/8/26.
//

import Foundation
import MapKit

enum RouteOptionType: String, CaseIterable, Identifiable {
    case recommended = "Recommended"
    case fastest = "Fastest"
    case simplest = "Simplest"

    var id: String {
        rawValue
    }

    var systemImage: String {
        switch self {
        case .recommended:
            return "sparkles"
        case .fastest:
            return "bolt.fill"
        case .simplest:
            return "arrow.triangle.turn.up.right.circle.fill"
        }
    }
}

struct RouteOption: Identifiable {
    let id = UUID()
    let type: RouteOptionType
    let route: MKRoute
    let accessibilityScore: Int
    let reason: String

    var title: String {
        type.rawValue
    }

    var travelTimeText: String {
        let minutes = Int(route.expectedTravelTime / 60)
        return "\(max(minutes, 1)) min"
    }

    var distanceText: String {
        let miles = route.distance / 1609.34
        return String(format: "%.1f mi", miles)
    }

    var stepCount: Int {
        route.steps.filter { !$0.instructions.isEmpty }.count
    }
}
