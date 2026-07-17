import Foundation

enum DemoLocation: String, Identifiable, Hashable {
    case loomis
    case gathersTeaBar
    case daleyLibrary
    case academicResidentialComplex
    case studentRecreationFacility
    case behavioralSciencesBuilding
    case studentCenterEast
    case scienceEngineeringSouth
    case jamesStukelTowers
    case creditUnionOneArena
    case studentResidenceCommonsCourtyard

    var id: String {
        rawValue
    }

    var name: String {
        switch self {
        
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
            
        case .behavioralSciencesBuilding:
            return "Behavioral Sciences Building"
        
        case .studentCenterEast:
            return "Student Center East"
        
        case .jamesStukelTowers:
            return "James Stukel Towers"
        
        case .creditUnionOneArena:
            return "Credit Union 1 Arena"
        
        case .studentResidenceCommonsCourtyard:
            return "Student Residence Commons Courtyard"
        
        case .scienceEngineeringSouth:
            return "Science and Engineering South"
        }
    }

    var address: String {
        switch self {

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
            
        case .behavioralSciencesBuilding:
            return "1007 W Harrison St, Chicago IL"
            
        case .studentCenterEast:
            return "Student Center East, 750 S Halsted St"

        case .scienceEngineeringSouth:
            return "Science and Engineering South, 845 W Taylor St"

        case .jamesStukelTowers:
            return "James J. Stukel Towers, 718 W James M. Rochford St"

        case .creditUnionOneArena:
            return "Credit Union 1 Arena, 525 S Racine Ave"

        case .studentResidenceCommonsCourtyard:
            return "Courtyard, Student Residence and Commons, 700 S Halsted St"
        }
        
        
        
    }

    var systemImage: String {
        switch self {

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
            
        case .behavioralSciencesBuilding:
            return "brain.head.profile"
            
        case .studentCenterEast:
            return "fork.knife"

        case .scienceEngineeringSouth:
            return "atom"

        case .jamesStukelTowers:
            return "building.fill"

        case .creditUnionOneArena:
            return "sportscourt.fill"

        case .studentResidenceCommonsCourtyard:
            return "house.fill"
        }
    }

    static let startingOptions: [DemoLocation] = [
        .loomis,
        .gathersTeaBar,
        .daleyLibrary,
        .academicResidentialComplex,
        .studentRecreationFacility,
        .behavioralSciencesBuilding,
        .studentCenterEast,
        .scienceEngineeringSouth,
        .jamesStukelTowers,
        .creditUnionOneArena,
        .studentResidenceCommonsCourtyard
        
    ]

    static let destinationOptions: [DemoLocation] = [
        .gathersTeaBar,
        .daleyLibrary,
        .academicResidentialComplex,
        .studentRecreationFacility,
        .loomis,
        .behavioralSciencesBuilding,
        .studentCenterEast,
        .scienceEngineeringSouth,
        .jamesStukelTowers,
        .creditUnionOneArena,
        .studentResidenceCommonsCourtyard
        
    ]
}
