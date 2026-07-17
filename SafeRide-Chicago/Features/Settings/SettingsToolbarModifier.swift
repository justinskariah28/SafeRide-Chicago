
//
//  SettingsToolbarModifier.swift
//  SafeRide-Chicago
//

import SwiftUI

struct SettingsToolbarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(Color.safeRoutePurple)
                    }
                    .accessibilityLabel("Settings")
                    .accessibilityHint(
                        "Opens the SafeRide settings page"
                    )
                }
            }
    }
}

extension View {
    func settingsToolbar() -> some View {
        modifier(SettingsToolbarModifier())
    }
}

