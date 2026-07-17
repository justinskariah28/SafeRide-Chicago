//TRIPFEEDBACK


import SwiftUI
struct TripFeedback: View {
    @State private var answered = false
    @State private var rating = 0
    @State private var selectedAnswer = "none"
    @State private var comments = ""
    @State private var showThankYou = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: Heading
                VStack(alignment: .leading, spacing: 10) {
                    Text("Trip Feedback")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(Color.safeRoutePurple)
                    Text("Thank you for using SafeRoute Chicago!")
                        .font(.system(size: 17))
                        .foregroundStyle(.secondary)
                }
                // MARK: Rating
                VStack(alignment: .leading, spacing: 16) {
                    Text("Please rate your trip *")
                        .font(.headline)
                    HStack(spacing: 12) {
                        ForEach(1...5, id: \.self) { star in
                            Button {
                                rating = star
                            } label: {
                                Image(
                                    systemName:
                                        star <= rating
                                        ? "star.fill"
                                        : "star"
                                )
                                .font(.system(size: 40))
                                .foregroundStyle(Color.safeRoutePurple)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.safeRoutePurple.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                // MARK: Accessibility Question
                VStack(alignment: .leading, spacing: 12) {
                    Text("Did this trip meet your accessibility needs? *")
                        .font(.headline)
                    feedbackOption("Yes")
                    feedbackOption("Maybe")
                    feedbackOption("No")
                   /* if selectedAnswer == "No" {
                        NavigationLink {
                            ReportFormView()
                        } label: {
                            Text("Fill Out Report Form")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color.safeRoutePurple)
                        }
                        .padding(.top, 4)
                    } */
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.safeRoutePurple.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                // MARK: Comments
                VStack(alignment: .leading, spacing: 12) {
                    Text("Additional Comments")
                        .font(.headline)
                    TextEditor(text: $comments)
                        .frame(height: 90)
                        .padding(6)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.25))
                        }
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.safeRoutePurple.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                // MARK: Validation / Submit
                if rating == 0 || selectedAnswer == "none" {
                    Text("*Please fill out all required fields.")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                } else {
                    Button("Submit Feedback") {
                        showThankYou=true
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .foregroundStyle(.white)
                    .background(Color.safeRoutePurple)
                    .clipShape(Capsule())
                }
                // MARK: Report Form Link
                HStack(spacing: 4) {
                    Text("Issue with your trip?")
                        .foregroundStyle(.secondary)
                    NavigationLink {
                        ReportFormView()
                    } label: {
                        Text("Fill Out Report Form")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.safeRoutePurple)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxWidth: .infinity)
                NavigationLink(
                    destination: FeedbackSubmittedView(),
                    isActive: $showThankYou
                ) {
                    EmptyView()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        //.settingsToolbar()
    }
    // MARK: Feedback Option Row
    @ViewBuilder
    private func feedbackOption(_ option: String) -> some View {
        Button {
            selectedAnswer = option
        } label: {
            HStack(spacing: 12) {
                Image(
                    systemName:
                        selectedAnswer == option
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.system(size: 22))
                .foregroundStyle(
                    selectedAnswer == option
                    ? Color.safeRoutePurple
                    : .secondary
                )
                Text(option)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                selectedAnswer == option
                ? Color.safeRoutePurple.opacity(0.12)
                : Color.gray.opacity(0.05)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        selectedAnswer == option
                        ? Color.safeRoutePurple
                        : Color.gray.opacity(0.20),
                        lineWidth: selectedAnswer == option ? 2 : 1
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}
#Preview {
    NavigationStack {
        TripFeedback()
    }
}

