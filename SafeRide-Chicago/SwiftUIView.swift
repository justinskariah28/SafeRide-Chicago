//
//  SwiftUIView.swift
//  SafeRide-Chicago
//
//
//

import SwiftUI

struct SwiftUIView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var text1 = ""
    var body: some View {
        VStack(spacing: 20) {
            Text("Report Form")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.red)
                .italic()
                .underline()
            Text("Please fill out the form below")
            TextField("Name", text: $name)
            TextField("Email", text: $email)
        }
        .padding(20)
        VStack(alignment: .leading , spacing: 20){
            //question
              Text("* Issue with recommend Route?")
              Text("* construction work?")
              Text("* Road/entrance blocked?")
              Text("* No accessible entrances?")
              Text("* Dim lighting?")
              Text("* Too Crowded?")
              Text("* Other:_")
              Text("Please descibe your issue below")
                TextField("Description", text: $text1)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(20)
        Button("Submit") {
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(20)
    }
}

#Preview {
    SwiftUIView()
}
