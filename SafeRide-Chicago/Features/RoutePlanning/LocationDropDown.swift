import SwiftUI

struct LocationDropDown: View {
    let label: String
    let placeholder: String
    let systemImage: String
    let options: [DemoLocation]

    @Binding var selection: DemoLocation?

    var body: some View {
        Menu {
            ForEach(options) { location in
                Button {
                    selection = location
                } label: {
                    HStack {
                        Label(
                            location.name,
                            systemImage: location.systemImage
                        )

                        if selection == location {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.safeRoutePurple)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)

                    Text(selection?.name ?? placeholder)
                        .font(.system(size: 17))
                        .foregroundStyle(
                            selection == nil
                                ? Color.secondary
                                : Color.primary
                        )
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.safeRoutePurple)
            }
            .padding(.horizontal, 16)
            .frame(height: 70)
            .background(Color.safeRoutePurple.opacity(0.08))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color.safeRoutePurple.opacity(0.18),
                        lineWidth: 1
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityValue(selection?.name ?? "Not selected")
        .accessibilityHint("Double tap to choose a location")
    }
}
