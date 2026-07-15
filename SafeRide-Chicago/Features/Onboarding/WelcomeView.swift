import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // App title and tagline
            VStack(alignment: .leading, spacing: 16) {
                Text("SafeRoute")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Color.safeRoutePurple)

                Text("An Accessable \nWay To Travel")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.black)
            }

            Spacer()

            // Navigation symbol
            HStack {
                Spacer()

                Image(systemName: "location.north.line")
                    .font(.system(size: 58, weight: .regular))
                    .foregroundStyle(.black)

                Spacer()
            }

            Spacer()

            // Buttons
            VStack(spacing: 16) {
                NavigationLink {
                    RouteSelectionView()
                } label: {
                    Label("Get Started", systemImage: "arrow.right")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundStyle(.white)
                        .background(Color.safeRoutePurple)
                        .clipShape(Capsule())
                }

                NavigationLink {
                    RouteSelectionView()
                } label: {
                    Label("Continue as Guest", systemImage: "person")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundStyle(.white)
                        .background(Color.safeRouteLightPurple)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 45)
        .padding(.bottom, 30)
        .background(Color.white)
    }
}

extension Color {
    static let safeRoutePurple = Color(
        red: 71 / 255,
        green: 56 / 255,
        blue: 76 / 255
    )

    static let safeRouteLightPurple = Color(
        red: 104 / 255,
        green: 94 / 255,
        blue: 118 / 255
    )
}

#Preview {
    WelcomeView()
}
