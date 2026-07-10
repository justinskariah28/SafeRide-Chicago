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
                HStack {
                    Label(option.title, systemImage: option.type.systemImage)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.safeRoutePurple)

                    Spacer()

                    Text("\(option.accessibilityScore)%")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.safeRoutePurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.safeRoutePurple.opacity(0.12))
                        .clipShape(Capsule())
                }

                HStack(spacing: 16) {
                    Label(option.travelTimeText, systemImage: "clock")
                    Label(option.distanceText, systemImage: "map")
                    Label("\(option.stepCount) steps", systemImage: "list.number")
                }
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

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
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Text("Preview requires a real MKRoute.")
}//  Created by 6 BGCC Loan Library on 7/8/26.
//

