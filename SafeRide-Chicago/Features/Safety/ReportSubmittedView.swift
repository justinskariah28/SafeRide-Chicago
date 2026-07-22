//
//  FeedbackSubmittedView.swift
//  SafeRide-Chicago
//
//  Created by 30 BGCC Loan Library on 7/17/26.
//


//  FeedbackSubmittedView.swift
//  SafeRide-Chicago
//
//  Created by 30 BGCC Loan Library on 7/15/26.
//
import SwiftUI
struct ReportSubmittedView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.safeRoutePurple)
            Text("Thank You!")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color.safeRoutePurple)
            Text("Thank you for your report.")
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Spacer()
            NavigationLink {
                WelcomeView()
            } label: {
                Text("Return to Trip Selection")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .foregroundStyle(.white)
                    .background(Color.safeRoutePurple)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
       .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    NavigationStack {
        ReportSubmittedView()
    }
}


