//
//  RouteOptionCard.swift
//  SafeRide-Chicago
//

import SwiftUI

struct RouteOptionCard: View {
    let option: RouteOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {

                // Route name on the left, AI rating on the right
                HStack(alignment: .top) {
                    Label(
                        option.title,
                        systemImage: option.type.systemImage
                    )
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.safeRoutePurple)

                    Spacer()

                    if let rating = option.predictedRating {
                        VStack(alignment: .center, spacing: 2) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")

                                Text("\(rating, specifier: "%.1f")")
                                    .font(.system(size: 20, weight: .bold))
                            }
                            .foregroundStyle(Color.safeRoutePurple)

                            Text("Rating")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 11)
                        .padding(.vertical, 7)
                        .background(
                            Color.safeRoutePurple.opacity(0.12)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                    }
                }

                // Route information
                HStack(spacing: 16) {
                    Label(
                        option.travelTimeText,
                        systemImage: "clock"
                    )

                    Label(
                        option.distanceText,
                        systemImage: "map"
                    )

                    Label(
                        "\(option.stepCount) steps",
                        systemImage: "list.number"
                    )
                }
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

                // Accessibility score moved lower
                HStack(spacing: 6) {
                    Image(systemName: "accessibility")

                    Text("Accessibility score")

                    Spacer(minLength: 0)

                    Text("\(option.accessibilityScore)%")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.safeRoutePurple)
                .padding(.trailing, 12)
                .padding(.vertical, 9)
                .background(
                    Color.safeRoutePurple.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )

                Text(option.reason)
                    .font(.system(size: 15))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .background(
                isSelected
                    ? Color.safeRoutePurple.opacity(0.12)
                    : Color.gray.opacity(0.06)
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
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Text("Preview requires a real MKRoute.")
}
