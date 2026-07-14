//
//  TripFeedback.swift
//  SafeRide-Chicago
//
//  Created by 30 BGCC Loan Library on 7/8/26.
//

//
//  ContentView.swift
//  SafeRide-Chicago
//
//  Created by 6 BGCC Loan Library on 7/7/26.
//

import SwiftUI

struct TripFeedback: View {
    @State private var answered = false;
    @State private var rating = 0
    @State private var selectedAnswer = "none"
    @State private var comments = ""
    
    var body: some View {
        
        VStack {
            //Image(systemName: "globe")
               // .imageScale(.large)
               // .foregroundStyle(.tint)
            
            Text("Trip Feedback")
                .font(.title)
            
            Text("Thank you for using SafeRoute Chicago!")
                .padding(.top, 5)
            Spacer()
               Text("Please rate your trip.*")
                   //.padding(.top, 40)
            
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        rating = star
                    } label: {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.largeTitle)
                    }
                }
            }
            .padding(.top, 10)
            
            
                Spacer()
               Text("Did this trip meet your accessibility needs?*")
                
                
                VStack{
                    
                    Button("Yes") {
                         selectedAnswer = "Yes"
                        
                     }
                    .padding()
                    .frame(maxWidth: .infinity)
                        .background(selectedAnswer == "Yes" ? .blue : .gray.opacity(0.2))
                        .foregroundColor(selectedAnswer == "Yes" ? .white : .primary)
                        .cornerRadius(10)

                     Button("Maybe") {
                         selectedAnswer = "Maybe"
                     }
                     .padding()
                     .frame(maxWidth: .infinity)
                         .background(selectedAnswer == "Maybe" ? .blue : .gray.opacity(0.2))
                         .foregroundColor(selectedAnswer == "Maybe" ? .white : .primary)
                         .cornerRadius(10)

                     Button("No") {
                         selectedAnswer = "No"
                     }
                     .padding()
                     .frame(maxWidth: .infinity)
                         .background(selectedAnswer == "No" ? .blue : .gray.opacity(0.2))
                         .foregroundColor(selectedAnswer == "No" ? .white : .primary)
                         .cornerRadius(10)
                }
            
            /*if (selectedAnswer == "No"){
                Spacer()
                Button("Fill out report form"){
                    
                }
            }*/
            
            
            Spacer()
               Text("Provide any additional comments below.")
            
            
            
            TextEditor(text: $comments)
                .frame(height: 140)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.5))
                )
            
            Spacer()
            if (rating == 0 || selectedAnswer == "none"){
                Text("*Please fill out all required fields.")
            }
            
            else{
                Button("Submit"){
                    
                }
            }

           
            Spacer()
            
           
        
            HStack(){
                Text("Issue with your trip?")
                    Button("Fill out report form."){
                        
                    }
            }
          
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
   
}

#Preview {
    TripFeedback()
}
