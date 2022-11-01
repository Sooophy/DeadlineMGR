//
//  EventDetail.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI


struct EventDetail: View {
    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var modelData: ModelData
//    @State var event: Event
//
    
    @State private var eventTitle: String = "564 Project Sprint1"
    @State private var tag:String = "ECE564"
    @State private var date:Date = Date.now
    @State private var description = "Sprint 1 (Complete on Nov 1). Design and Architecture done.  Data model developed and implementation started (Server / File / DB / 3rd party / etc).  Flow of UI completed (look and feel and flow of Views) and decision made on UI model (code / storyboard / .xib / SwiftUI).  Basic UI screens with VCs completed."
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    TextField("Event Title", text: $eventTitle, axis: .vertical)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 1)
                    HStack {
                        DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                            Text("Due:")
                        }

                        Spacer()
                        
                        HStack {
                            Text("Tag:")
                            TextField("Tag", text: $tag)
                        }
                        .padding(.leading, 50)
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                    
                    Divider()
                    Text("Description:")
                        .padding(.bottom, 10)
                    TextField("Description", text: $description, axis: .vertical)
    //                    .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.leading)
                    
                }
                .padding()
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
            Button(action : { self.presentationMode.wrappedValue.dismiss() }){
                Text("Cancel")
            },
            trailing:
            Button(action : { saveEvent() }){
                Text("Save")
        })
    }
    
    func saveEvent(){
        //save event
        self.presentationMode.wrappedValue.dismiss()
    }
    
}


struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail()
    }
}
