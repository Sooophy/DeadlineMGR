//
//  EventDetail.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI


struct EventDetail: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData
    var event: Event
    
    @State private var eventTitle: String = ""
    @State private var tag:String  = ""
    @State private var due:Date = Date()
    @State private var description : String = ""
    @State private var isCompleted : Bool = false
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    TextField("Event Title", text: $eventTitle, axis: .vertical)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 1)
                    VStack(alignment: .leading) {
                        DatePicker(selection: $due, in: ...Date()) {
                            Text("Due:")
                        }

//                        Spacer()
                        
                        HStack {
                            Text("Tag:")
                            TextField("Tag", text: $tag)
                        }
//                        .padding(.leading, 50)
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
        .onAppear(){
            (eventTitle, tag, due, description, isCompleted) = showEventDetail(event: event)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
            Button(action : { self.presentationMode.wrappedValue.dismiss() }){
                Text("Cancel")
            },
            trailing:
                Button(action : { saveEvent(event: event) }){
                Text("Save")
        })
    }
    
    func saveEvent(event : Event){
        //save event
        let newEvent = modifyEvent(event: event, eventTitle: eventTitle, tag: tag, due: due, description: description, isCompleted: isCompleted)
        modelData.dataBase[newEvent.id] = newEvent
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func showEventDetail(event: Event) -> (String, String, Date, String, Bool) {
        return (event.title, event.tag.joined(separator: ","), event.dueAt, event.description, event.isCompleted)
    }
    
    func modifyEvent(event: Event, eventTitle: String, tag: String, due: Date, description: String, isCompleted: Bool) -> Event {
        var newEvent = event
        newEvent.title = eventTitle
        newEvent.tag = tag.components(separatedBy: ",")
        newEvent.dueAt = due
        newEvent.description = description
        newEvent.isCompleted = isCompleted
        return newEvent
    }
    
}


struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(event: ModelData().dataBase["C8F55DF8-BE79-451E-8F66-9318CA0A686C"]!)
    }
}
