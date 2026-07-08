
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
        case .walking:
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
                ),
                TravelPreference(
                    title: "Avoid steep hills",
                    description: "Prioritize flatter walking routes",
                    systemImage: "mountain.2"
                ),
                TravelPreference(
                    title: "Low-sensory route",
                    description: "Avoid crowded or noisy areas",
                    systemImage: "speaker.slash.fill"
                ),
                TravelPreference(
                    title: "Simple directions",
                    description: "Use fewer turns and clearer instructions",
                    systemImage: "list.bullet"
                )
            ]

        case .transit:
            return [
                TravelPreference(
                    title: "Elevator-accessible stations",
                    description: "Use stations with step-free access",
                    systemImage: "arrow.up.arrow.down.square"
                ),
                TravelPreference(
                    title: "Minimize transfers",
                    description: "Use fewer buses or trains",
                    systemImage: "arrow.triangle.swap"
                ),
                TravelPreference(
                    title: "Shorter walking distance",
                    description: "Reduce walking before and after transit",
                    systemImage: "figure.walk"
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
                ),
                TravelPreference(
                    title: "Avoid crowded stations",
                    description: "Prefer less crowded transit locations",
                    systemImage: "person.3.fill"
                ),
                TravelPreference(
                    title: "Accessible boarding",
                    description: "Prioritize accessible buses and trains",
                    systemImage: "figure.roll"
                )
            ]

        case .driving:
            return [
                TravelPreference(
                    title: "Accessible parking",
                    description: "Find accessible parking near the destination",
                    systemImage: "parkingsign.circle.fill"
                ),
                TravelPreference(
                    title: "Minimize walking",
                    description: "Park closer to the destination entrance",
                    systemImage: "figure.walk"
                ),
                TravelPreference(
                    title: "Well-lit arrival area",
                    description: "Prioritize safer, well-lit parking areas",
                    systemImage: "lightbulb.fill"
                ),
                TravelPreference(
                    title: "Avoid difficult intersections",
                    description: "Choose routes with simpler turns",
                    systemImage: "arrow.triangle.turn.up.right.circle"
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
