//
//  ContentView.swift
//  SafeRide-Chicago
//
//  Created by 6 BGCC Loan Library on 7/7/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
            //Image(systemName: "globe")
               // .imageScale(.large)
               // .foregroundStyle(.tint)
            
            Text("Trip Feedback")
                .font(.title)

               Text("Please rate your trip.")
                   .padding(.top, 40)

               Text("Did this trip meet your accessibility needs?")
                @State var selectedAnswer = ""
                VStack{
                    Button("Yes") {
                         selectedAnswer = "Yes"
                     }

                     Button("Maybe") {
                         selectedAnswer = "Maybe"
                     }

                     Button("No") {
                         selectedAnswer = "No"
                     }
                }
               Text("Provide any additional comments below.")
             
               Text("Thank you for using SafeRoute Chicago!")
                .padding(.top, 475)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
   
}

#Preview {
    ContentView()
}
