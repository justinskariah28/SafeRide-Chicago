import Foundation

enum DemoLocation: String, Identifiable, Hashable {
    case currentLocation
    case loomis
    case gathersTeaBar
    case daleyLibrary
    case academicResidentialComplex
    case studentRecreationFacility

    var id: String {
        rawValue
    }

    var name: String {
        switch self {
        case .currentLocation:
            return "Current Location"

        case .loomis:
            return "816 S Loomis St"

        case .gathersTeaBar:
            return "Gathers Tea Bar"

        case .daleyLibrary:
            return "Richard J. Daley Library"

        case .academicResidentialComplex:
            return "Academic and Residential Complex"

        case .studentRecreationFacility:
            return "UIC Student Recreation Facility"
        }
    }

    var address: String {
        switch self {
        case .currentLocation:
            return "Current Location"

        case .loomis:
            return "816 S Loomis St, Chicago, IL"

        case .gathersTeaBar:
            return "1214 W Taylor St, Chicago, IL"

        case .daleyLibrary:
            return "801 S Morgan St, Chicago, IL"

        case .academicResidentialComplex:
            return "940 W Harrison St, Chicago, IL"

        case .studentRecreationFacility:
            return "737 S Halsted St, Chicago, IL"
        }
    }

    var systemImage: String {
        switch self {
        case .currentLocation:
            return "location.fill"

        case .loomis:
            return "house.fill"

        case .gathersTeaBar:
            return "cup.and.saucer.fill"

        case .daleyLibrary:
            return "books.vertical.fill"

        case .academicResidentialComplex:
            return "building.2.fill"

        case .studentRecreationFacility:
            return "figure.run"
        }
    }

    static let startingOptions: [DemoLocation] = [
        .currentLocation,
        .loomis,
        .gathersTeaBar,
        .daleyLibrary,
        .academicResidentialComplex,
        .studentRecreationFacility
    ]

    static let destinationOptions: [DemoLocation] = [
        .gathersTeaBar,
        .daleyLibrary,
        .academicResidentialComplex,
        .studentRecreationFacility,
        .loomis
    ]
}
