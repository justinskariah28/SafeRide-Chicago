//
//  SwiftUIView.swift
//  SafeRide-Chicago
//
//
// not in use??

import PhotosUI
import SwiftUI

struct SwiftUIView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var text1 = ""
    @State private var selectedItem: [PhotosPickerItem] = []
    var body: some View {
        ScrollView{
            VStack(spacing: 8) {
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
            VStack(alignment: .leading , spacing: 8){
                //questions
                Text("* Issue with recommend Route?")
                Text("* construction work?")
                Text("* Road/entrance blocked?")
                Text("* No accessible entrances?")
                Text("* Dim lighting?")
                Text("* Too Crowded?")
                Text("* Other:______________")
                Text("Please descibe your issue below")
                TextEditor(text: $text1)
                    .frame(height: 150)
                    .padding(8)
                    .overlay( RoundedRectangle(cornerRadius: 8) .stroke(Color.gray.opacity(0.2)))
            }
            .padding(20)
            VStack(spacing: 4){
                Text("attachments")
                
                PhotosPicker(selection: $selectedItem, maxSelectionCount: 5, matching: .any(of: [.images, .videos]))
                {
                    Label("add any photos/videos", systemImage: "paperclip")
                }
                Text("\(selectedItem.count) attachments selected")
            }
            Button("Submit") {
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(20)
        }
    }
}

#Preview {
    SwiftUIView()
}
