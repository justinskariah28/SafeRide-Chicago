import SwiftUI
import MapKit

struct RouteSelectionView: View {
    @State private var startingLocation = "Current Location"
    @State private var destination = ""
    @State private var selectedMode: TravelMode = .walking
    @State private var resolvedDestination: MKMapItem?
    @State private var isSearching = false
    @State private var shouldShowPreferences = false
    @State private var errorMessage = ""
    @State private var showingError = false

    private var canContinue: Bool {
        !startingLocation.trimmingCharacters(in: .whitespaces).isEmpty &&
        !destination.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                // MARK: Title

                VStack(alignment: .leading, spacing: 8) {
                    Text("Where are you going?")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(Color.safeRoutePurple)

                    Text("Enter your trip and choose how you plan to travel.")
                        .font(.system(size: 17))
                        .foregroundStyle(.secondary)
                }

                // MARK: Location Fields

                VStack(spacing: 14) {
                    LocationTextField(
                        label: "From",
                        placeholder: "Starting location",
                        systemImage: "location.fill",
                        text: $startingLocation
                    )

                    LocationTextField(
                        label: "To",
                        placeholder: "Enter destination",
                        systemImage: "mappin.circle.fill",
                        text: $destination
                    )
                }

                // MARK: Travel Mode

                VStack(alignment: .leading, spacing: 14) {
                    Text("How are you traveling?")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.safeRoutePurple)

                    HStack(spacing: 10) {
                        ForEach(TravelMode.allCases) { mode in
                            TravelModeButton(
                                mode: mode,
                                isSelected: selectedMode == mode
                            ) {
                                selectedMode = mode
                            }
                        }
                    }
                }

                // MARK: Selected Mode Explanation

                HStack(spacing: 14) {
                    Image(systemName: selectedMode.systemImage)
                        .font(.system(size: 24))
                        .foregroundStyle(Color.safeRoutePurple)
                        .frame(width: 42, height: 42)
                        .background(Color.safeRoutePurple.opacity(0.10))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(selectedMode.rawValue) selected")
                            .font(.system(size: 16, weight: .semibold))

                        Text("Your accessibility preferences will be customized for this travel mode.")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(16)
                .background(Color.gray.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 18))

                Spacer(minLength: 20)

                // MARK: Continue Button

                NavigationLink {
                    TravelPreferencesView(
                        startingLocation: startingLocation,
                        destination: destination,
                        travelMode: selectedMode
                    )
                } label: {
                    Text("Choose Travel Preferences")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundStyle(.white)
                        .background(
                            canContinue
                                ? Color.safeRoutePurple
                                : Color.gray.opacity(0.45)
                        )
                        .clipShape(Capsule())
                }
                .disabled(!canContinue)
                .accessibilityHint(
                    canContinue
                        ? "Opens accessibility preferences"
                        : "Enter a destination before continuing"
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 40)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Location Text Field

struct LocationTextField: View {
    let label: String
    let placeholder: String
    let systemImage: String

    @Binding var text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 20))
                .foregroundStyle(Color.safeRoutePurple)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)

                TextField(placeholder, text: $text)
                    .font(.system(size: 17))
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Clear \(label) location")
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 70)
        .background(Color.safeRoutePurple.opacity(0.08))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.safeRoutePurple.opacity(0.18), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Travel Mode Button

struct TravelModeButton: View {
    let mode: TravelMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mode.systemImage)
                    .font(.system(size: 22))

                Text(mode.rawValue)
                    .font(.system(size: 14, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 82)
            .foregroundStyle(
                isSelected
                    ? Color.white
                    : Color.safeRoutePurple
            )
            .background(
                isSelected
                    ? Color.safeRoutePurple
                    : Color.safeRoutePurple.opacity(0.08)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color.safeRoutePurple.opacity(
                            isSelected ? 0 : 0.20
                        ),
                        lineWidth: 1
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(mode.rawValue)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(
            isSelected ? .isSelected : []
        )
    }
}

#Preview {
    NavigationStack {
        RouteSelectionView()
    }
}
