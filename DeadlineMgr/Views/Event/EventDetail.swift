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
    @State private var tag: String = ""
    @State private var due: Date = .init()
    @State private var description: String = ""
    @State private var isCompleted: Bool = false
    @State private var eventColor: Color = .blue
    @State private var location: Location = Location()
    
    var body: some View {
        Group {
            ScrollView {
                VStack(alignment: .leading) {
                    TextField("Event Title", text: $eventTitle, axis: .vertical)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 1)
                    VStack(alignment: .leading) {
                        DatePicker(selection: $due) {
                            Text("Due:")
                        }

//                        Spacer()
                        
                        HStack {
                            Text("Tag:")
                            TextField("Tag", text: $tag)
                        }
//                        .padding(.leading, 50)
                        
                        ColorPicker("event color:", selection: $eventColor)
                        
                        NavigationLink(destination: EventLocation(location: $location)) {
                            HStack {
                                Text("Location:")
                                Spacer(minLength: 5)
                                TextField("Location", text: $location.locationName)
                            }
                            .foregroundColor(.blue)
                        }
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
        .onAppear {
            (eventTitle, tag, due, description, isCompleted, eventColor, location) = showEventDetail(event: event)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Cancel")
            },
            trailing:
            Button(action: { saveEvent(event: event) }) {
                Text("Save")
            })
    }
    
    func saveEvent(event: Event) {
        // save event
        modelData.addUpdateEvent(id: event.id,
                                 title: eventTitle,
                                 dueAt: due,
                                 tag: tag,
                                 description: description,
                                 location: location,
                                 color: eventColor)
        presentationMode.wrappedValue.dismiss()
    }
    
    func showEventDetail(event: Event) -> (String, String, Date, String, Bool, Color, Location) {
        let eventLocation = event.location ?? Location()
        return (event.title, event.tag.joined(separator: ","), event.dueAt, event.description, event.isCompleted, Color: event.color, eventLocation)
    }
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(event: ModelData().dataBase["C8F55DF8-BE79-451E-8F66-9318CA0A686C"]!)
    }
}
