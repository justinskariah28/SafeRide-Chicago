import SwiftUI

struct TravelPreferencesView: View {
    let startingLocation: String
    let destination: String
    let travelMode: TravelMode

    @State private var selectedPreferences: Set<String> = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: Heading

                VStack(alignment: .leading, spacing: 10) {
                    Text(travelMode.preferenceTitle)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(Color.safeRoutePurple)

                    Text(travelMode.preferenceSubtitle)
                        .font(.system(size: 17))
                        .foregroundStyle(.secondary)
                }

                // MARK: Trip Summary

                TripSummaryCard(
                    startingLocation: startingLocation,
                    destination: destination,
                    travelMode: travelMode
                )

                // MARK: Preference Rows

                VStack(spacing: 12) {
                    ForEach(travelMode.preferences) { preference in
                        TravelPreferenceRow(
                            preference: preference,
                            isSelected: selectedPreferences.contains(
                                preference.id
                            )
                        ) {
                            togglePreference(preference)
                        }
                    }
                }

                Text("All preferences are optional.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)

            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                NavigationLink {
                    RouteResultsView(
                        startingLocation: startingLocation,
                        destination: destination,
                        travelMode: travelMode,
                        selectedPreferences: Array(selectedPreferences)
                    )
                } label: {
                    Text("Find Accessible Routes")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundStyle(.white)
                        .background(Color.safeRoutePurple)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
            .background(.ultraThinMaterial)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .settingsToolbar()
    }

    private func togglePreference(_ preference: TravelPreference) {
        if selectedPreferences.contains(preference.id) {
            selectedPreferences.remove(preference.id)
        } else {
            selectedPreferences.insert(preference.id)
        }
    }
}

// MARK: - Trip Summary

struct TripSummaryCard: View {
    let startingLocation: String
    let destination: String
    let travelMode: TravelMode

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: travelMode.systemImage)
                    .foregroundStyle(Color.safeRoutePurple)

                Text(travelMode.rawValue)
                    .font(.system(size: 16, weight: .semibold))
            }

            Divider()

            Label {
                Text(startingLocation)
            } icon: {
                Image(systemName: "location.fill")
            }

            Label {
                Text(destination)
            } icon: {
                Image(systemName: "mappin.circle.fill")
            }
        }
        .font(.system(size: 15))
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.safeRoutePurple.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

// MARK: - Preference Row

struct TravelPreferenceRow: View {
    let preference: TravelPreference
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: preference.systemImage)
                    .font(.system(size: 21))
                    .foregroundStyle(Color.safeRoutePurple)
                    .frame(width: 34)

                VStack(alignment: .leading, spacing: 4) {
                    Text(preference.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(preference.description)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(
                    systemName: isSelected
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.system(size: 24))
                .foregroundStyle(
                    isSelected
                        ? Color.safeRoutePurple
                        : Color.secondary.opacity(0.60)
                )
            }
            .padding(16)
            .background(
                isSelected
                    ? Color.safeRoutePurple.opacity(0.12)
                    : Color.gray.opacity(0.05)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isSelected
                            ? Color.safeRoutePurple
                            : Color.gray.opacity(0.20),
                        lineWidth: isSelected ? 2 : 1
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(preference.title)
        .accessibilityHint(preference.description)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(
            isSelected ? .isSelected : []
        )
    }
}

#Preview {
    NavigationStack {
        TravelPreferencesView(
            startingLocation: "Kaplan Institute",
            destination: "UIC",
            travelMode: .transit
        )
    }
}
