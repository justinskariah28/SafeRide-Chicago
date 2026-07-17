import Foundation

enum DemoDestination:
    String,
    CaseIterable,
    Identifiable,
    Hashable
{
    case gathersTeaBar
    case daleyLibrary

    var id: String {
        rawValue
    }

    var name: String {
        switch self {
        case .gathersTeaBar:
            return "Gathers Tea Bar"

        case .daleyLibrary:
            return "Richard J. Daley Library"
        }
    }

    var address: String {
        switch self {
        case .gathersTeaBar:
            return "1214 W Taylor St, Chicago, IL 60607"

        case .daleyLibrary:
            return "801 S Morgan St, Chicago, IL 60607"
        }
    }

    var systemImage: String {
        switch self {
        case .gathersTeaBar:
            return "cup.and.saucer.fill"

        case .daleyLibrary:
            return "books.vertical.fill"
        }
    }
}
