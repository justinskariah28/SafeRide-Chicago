import SwiftUI

struct SettingsView: View {
    
  /*  @AppStorage("highContrastEnabled")
    private var highContrastEnabled = false

    @AppStorage("largerButtonsEnabled")
    private var largerButtonsEnabled = false

    @AppStorage("reduceAnimationsEnabled")
    private var reduceAnimationsEnabled = false

    @AppStorage("hapticFeedbackEnabled")
    private var hapticFeedbackEnabled = true

    @AppStorage("spokenDirectionsEnabled")
    private var spokenDirectionsEnabled = false */

    var body: some View {
        List {
            Section("Support") {
                NavigationLink {
                    ReportFormView()
                } label: {
                    Label(
                        "Report an Issue",
                        systemImage: "exclamationmark.bubble"
                    )
                }
            }

            Section("About") {
                HStack {
                    Text("App")

                    Spacer()

                    Text("SafeRide Chicago")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Service Area")

                    Spacer()

                    Text("UIC Neighborhood")
                        .foregroundStyle(.secondary)
                }
            }

           /* Section("Accessibility") {
                Toggle(
                    "High Contrast",
                    isOn: $highContrastEnabled
                )

                Toggle(
                    "Larger Buttons",
                    isOn: $largerButtonsEnabled
                )

                Toggle(
                    "Reduce Animations",
                    isOn: $reduceAnimationsEnabled
                )

                Toggle(
                    "Haptic Feedback",
                    isOn: $hapticFeedbackEnabled
                )

                Toggle(
                    "Spoken Directions",
                    isOn: $spokenDirectionsEnabled
                )
            } */
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
