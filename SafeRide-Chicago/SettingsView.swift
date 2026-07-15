
//
//  SettingsView.swift
//  SafeRide-Chicago
//

import SwiftUI

struct SettingsView: View {
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
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

