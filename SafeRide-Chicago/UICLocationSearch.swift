import MapKit

enum UICLocationSearchError: LocalizedError {
    case emptySearch
    case noLocationInServiceArea

    var errorDescription: String? {
        switch self {
        case .emptySearch:
            return "Please enter a destination."

        case .noLocationInServiceArea:
            return """
            SafeRoute currently supports destinations between \
            Damen Avenue, Halsted Street, Harrison Street, \
            and Roosevelt Road.
            """
        }
    }
}

struct UICLocationSearch {

    static func findLocation(
        matching searchText: String
    ) async throws -> MKMapItem {

        let cleanedText = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedText.isEmpty else {
            throw UICLocationSearchError.emptySearch
        }

        let request = MKLocalSearch.Request(
            naturalLanguageQuery: "\(cleanedText), Chicago, IL",
            region: UICServiceArea.region
        )

        request.resultTypes = [
            .address,
            .pointOfInterest
        ]

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        let validResult = response.mapItems.first { mapItem in
            UICServiceArea.contains(
                mapItem.placemark.coordinate
            )
        }

        guard let validResult else {
            throw UICLocationSearchError.noLocationInServiceArea
        }

        return validResult
    }
}
