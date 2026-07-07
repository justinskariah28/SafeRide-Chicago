//
//  SwiftUIView.swift
//  SafeRide-Chicago
//
//  Created by 17 BGCC Loan Library on 7/7/26.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""
    var body: some View {
        VStack(spacing: 20) {
            Text("Report Form")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.red)
                .italic()
                .underline()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Please fill out the form below")
            TextField("Name", text: $name)
            TextField("Email", text: $email)
            //first Question
            Text("please explain how your trip was."+("        "))
            TextField("Description", text: $text1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            //second Question
            Text("Did you feel the experience met your acessibility needs.")
            TextField("Description", text: $text2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            //Third Question
            Text("Please explain how we could improve the app.")
            TextField("Description", text: $text3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Submit") {
            }
            .buttonStyle(BorderlessButtonStyle())
          
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(30)
        
    }
}

#Preview {
    SwiftUIView()
}
