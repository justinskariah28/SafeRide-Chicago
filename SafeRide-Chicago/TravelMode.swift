
import Foundation

enum TravelMode: String, CaseIterable, Identifiable, Hashable {
    case walking = "Walk"
    case transit = "Transit"
    case driving = "Drive"

    var id: String {
        rawValue
    }

    var systemImage: String {
        switch self {
        case .walking:
            return "figure.walk"
        case .transit:
            return "bus.fill"
        case .driving:
            return "car.fill"
        }
    }

    var preferenceTitle: String {
        switch self {
        case .walking:
            return "What matters for your walk?"
        case .transit:
            return "What matters for your transit trip?"
        case .driving:
            return "What matters for your drive?"
        }
    }

    var preferenceSubtitle: String {
        switch self {
        case .walking:
            return "Choose features that make your walking route safer and easier."
        case .transit:
            return "Choose features that make your public transit trip more accessible."
        case .driving:
            return "Choose features that make driving and arriving easier."
        }
    }

    var preferences: [TravelPreference] {
        switch self {
        case .walking:                                                          //Travel Preferences for Walking
            return [
                TravelPreference(
                    title: "Step-free route",
                    description: "Avoid stairs and inaccessible entrances",
                    systemImage: "figure.roll"
                ),
                TravelPreference(
                    title: "Fewer crossings",
                    description: "Avoid complicated intersections",
                    systemImage: "signpost.right"
                ),
                TravelPreference(
                    title: "Well-lit streets",
                    description: "Prioritize streets with better lighting",
                    systemImage: "lightbulb.fill"
                ),
                TravelPreference(
                    title: "Nearby Safe Spots",
                    description: "Stay near verified community locations",
                    systemImage: "shield.checkered"
                )
            ]

        case .transit:                                                          //Travel Preferences for Public Transportation
            return [
                TravelPreference(
                    title: "Elevator-accessible stations",
                    description: "Use stations with step-free access",
                    systemImage: "arrow.up.arrow.down.square"
                ),
                TravelPreference(
                    title: "Seated waiting areas",
                    description: "Prioritize stops with available seating",
                    systemImage: "chair.fill"
                ),
                TravelPreference(
                    title: "Covered waiting areas",
                    description: "Prioritize stops protected from weather",
                    systemImage: "umbrella.fill"
                )
            ]

        case .driving:                                                          //Travel Preferences for Driving
            return [
                TravelPreference(
                    title: "Accessible parking",
                    description: "Find accessible parking near the destination",
                    systemImage: "parkingsign.circle.fill"
                ),
                TravelPreference(
                    title: "Well-lit arrival area",
                    description: "Prioritize safer, well-lit parking areas",
                    systemImage: "lightbulb.fill"
                ),
                TravelPreference(
                    title: "Avoid highways",
                    description: "Remain on local streets when possible",
                    systemImage: "road.lanes"
                ),
                TravelPreference(
                    title: "Avoid tolls",
                    description: "Choose routes without toll roads",
                    systemImage: "dollarsign.circle"
                )
            ]
        }
    }
}

struct TravelPreference: Identifiable, Hashable {
    let title: String
    let description: String
    let systemImage: String

    var id: String {
        title
    }
}
