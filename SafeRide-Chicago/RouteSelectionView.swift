
//
//  RouteSelectionView.swift
//  SafeRide-Chicago
//

import SwiftUI

// MARK: - Route Selection Screen

struct RouteSelectionView: View {
    @State private var selectedStartingLocation: DemoLocation? = .loomis
    @State private var selectedDestination: DemoLocation?
    @State private var selectedMode: TravelMode = .walking

    private var canContinue: Bool {
        guard let start = selectedStartingLocation,
              let destination = selectedDestination else {
            return false
        }

        return start != destination
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                // MARK: Heading

                VStack(alignment: .leading, spacing: 8) {
                    Text("Where are you going?")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(Color.safeRoutePurple)

                    Text(
                        "Choose your starting point, destination, and travel method."
                    )
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
                }

                // MARK: Location Dropdowns

                VStack(spacing: 14) {
                    LocationDropDown(
                        label: "From",
                        placeholder: "Choose starting location",
                        systemImage: "location.fill",
                        options: DemoLocation.startingOptions,
                        selection: $selectedStartingLocation
                    )

                    LocationDropDown(
                        label: "To",
                        placeholder: "Choose destination",
                        systemImage: "mappin.circle.fill",
                        options: DemoLocation.destinationOptions,
                        selection: $selectedDestination
                    )
                }

                // MARK: Travel Mode

                VStack(alignment: .leading, spacing: 14) {
                    Text("How are you traveling?")
                        .font(.system(size: 24, weight: .bold))
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
                        .frame(width: 44, height: 44)
                        .background(
                            Color.safeRoutePurple.opacity(0.10)
                        )
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(selectedMode.rawValue) selected")
                            .font(
                                .system(
                                    size: 17,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "Your accessibility preferences will be customized for this travel mode."
                        )
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.06))
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )

                // MARK: Trip Preview

                if let start = selectedStartingLocation,
                   let destination = selectedDestination {

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your trip")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(Color.safeRoutePurple)

                        Label(
                            start.name,
                            systemImage: "location.fill"
                        )

                        Label(
                            destination.name,
                            systemImage: "mappin.circle.fill"
                        )
                    }
                    .font(.system(size: 15))
                    .padding(16)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(
                        Color.safeRoutePurple.opacity(0.08)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                }

                // MARK: Continue

                NavigationLink {
                    if let start = selectedStartingLocation,
                       let destination = selectedDestination {

                        TravelPreferencesView(
                            startingLocation: start.address,
                            destination: destination.address,
                            travelMode: selectedMode
                        )
                    }
                } label: {
                    Text("Choose Travel Preferences")
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )
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
                        ? "Opens travel accessibility preferences"
                        : "Choose a destination before continuing"
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 40)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)

        // MARK: Settings Gear

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(Color.safeRoutePurple)
                }
                .accessibilityLabel("Settings")
            }
        }
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
                    .font(.system(size: 25))

                Text(mode.rawValue)
                    .font(
                        .system(
                            size: 15,
                            weight: .semibold
                        )
                    )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 94)
            .foregroundStyle(
                isSelected
                    ? Color.white
                    : Color.safeRoutePurple
            )
            .background(
                isSelected
                    ? Color.safeRoutePurple
                    : Color.gray.opacity(0.08)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isSelected
                            ? Color.clear
                            : Color.gray.opacity(0.20),
                        lineWidth: 1
                    )
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(mode.rawValue)
        .accessibilityValue(
            isSelected ? "Selected" : "Not selected"
        )
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

