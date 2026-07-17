
import SwiftUI

struct AnalyzingRoutesView: View {
    let startingLocation: String
    let destination: String
    let travelMode: TravelMode
    let selectedPreferences: [String]

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            ProgressView()
                .controlSize(.large)
                .tint(Color.safeRoutePurple)

            VStack(spacing: 10) {
                Text("Finding your best route")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.safeRoutePurple)

                Text("Comparing available routes using your travel and accessibility preferences.")
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: 12) {
                Label("\(startingLocation) to \(destination)", systemImage: "mappin.and.ellipse")

                Label(travelMode.rawValue, systemImage: travelMode.systemImage)

                Label("\(selectedPreferences.count) preferences selected", systemImage: "checkmark.circle")
            }
            .font(.system(size: 16))
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.safeRoutePurple.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 18))

            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AnalyzingRoutesView(
        startingLocation: "Kaplan Institute",
        destination: "UIC",
        travelMode: .transit,
        selectedPreferences: [
            "Elevator-accessible stations",
            "Minimize transfers"
        ]
    )
}
