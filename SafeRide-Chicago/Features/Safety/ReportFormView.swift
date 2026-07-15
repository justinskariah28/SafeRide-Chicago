
//
//  ReportFormView.swift
//  SafeRide-Chicago
//
//  Improved styling for report form
//

import PhotosUI
import SwiftUI

struct ReportFormView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var descriptionText = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var submitting = false
    @State private var selectedIssues: Set<String> = []

    let issues = [
        "Issue with recommended route",
        "Construction work",
        "Road or entrance blocked",
        "No accessible entrances",
        "Dim lighting",
        "Too crowded",
        "Other (describe below)"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Report an Issue")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Color.safeRoutePurple)

                    Text("Help us improve SafeRoute by reporting issues you encounter.")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)

                // Contact Info Card
                formCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Your information")
                            .font(.headline)
                            .foregroundStyle(Color.safeRoutePurple)

                        VStack(spacing: 12) {
                            LabeledField(
                                label: "Name",
                                placeholder: "Full name",
                                text: $name
                            )

                            LabeledField(
                                label: "Email",
                                placeholder: "name@example.com",
                                text: $email,
                                keyboardType: .emailAddress
                            )
                        }
                    }
                }

                // Issue Type Card
                formCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("What happened?")
                            .font(.headline)
                            .foregroundStyle(Color.safeRoutePurple)

                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(issues, id: \.self) { issue in
                                Button(action: {
                                    if selectedIssues.contains(issue) {
                                        selectedIssues.remove(issue)
                                    } else {
                                        selectedIssues.insert(issue)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName:
                                            selectedIssues.contains(issue)
                                            ? "checkmark.square.fill"
                                            : "square"
                                        )

                                        Text(issue)

                                        Spacer()
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                        }

                        
                    }
                }

                // Attachments Card
                formCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Attachments (optional)")
                            .font(.headline)
                            .foregroundStyle(Color.safeRoutePurple)

                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: 5,
                            matching: .any(of: [.images, .videos])
                        ) {
                            Label(
                                "Add photos or videos",
                                systemImage: "paperclip"
                            )
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .foregroundStyle(.white)
                            .background(Color.safeRoutePurple)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                        }
                        .buttonStyle(.plain)

                        Text("\(selectedItems.count) attachment(s) selected")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                // Submit Button
                Button(action: submit) {
                    HStack(spacing: 10) {
                        if submitting {
                            ProgressView()
                                .tint(.white)
                        }

                        Text(
                            submitting
                                ? "Submitting…"
                                : "Submit Report"
                        )
                        .font(.system(size: 17, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .foregroundStyle(.white)
                    .background(
                        name.isEmpty ||
                        email.isEmpty ||
                        descriptionText
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                            ? Color.gray.opacity(0.45)
                            : Color.safeRoutePurple
                    )
                    .clipShape(Capsule())
                }
                .disabled(
                    name.isEmpty ||
                    email.isEmpty ||
                    descriptionText
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty ||
                    submitting
                )
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Color.white)
      //  .navigationTitle("Report Form")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func submit() {
        submitting = true

        // Simulate submission delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            submitting = false

            // Reset form
            name = ""
            email = ""
            descriptionText = ""
            selectedItems = []
        }
    }

    // Helpers
    @ViewBuilder
    private func formCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.06))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color.gray.opacity(0.20),
                        lineWidth: 1
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
            Text(text)
        }
        .font(.system(size: 15))
        .foregroundStyle(.primary)
    }
}

struct LabeledField: View {
    let label: String
    let placeholder: String

    @Binding var text: String

    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.words)
                .keyboardType(keyboardType)
                .padding(12)
                .background(Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            Color.gray.opacity(0.20),
                            lineWidth: 1
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    NavigationStack {
        ReportFormView()
    }
}

