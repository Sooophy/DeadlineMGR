//
//  EventDetail.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import CoreLocation
import LocationPicker
import MapKit
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
    @State private var location: Location = .init()
    var currentLocation: LocationItem? {
        if location.coordinate.latitude == 0.0 && location.coordinate.longitude == 0.0 {
            return nil
        }
        let mapItem = MKMapItem(placemark: .init(coordinate: location.coordinate))
        mapItem.name = location.locationName
        let locationItem = LocationItem(mapItem: mapItem)
        return locationItem
    }
    
    @State private var showLocationPicker: Bool = false
    @State private var selectedLocationItem: LocationItem? = nil
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
                        HStack {
                            Text("Tag:")
                            TextField("Tag", text: $tag)
                        }
                        ColorPicker("Event color:", selection: $eventColor)
                        
                        HStack {
                            Text("Location:")
                            Spacer(minLength: 5)
                            Text(location.locationName).onTapGesture {
                                showLocationPicker = true
                            }.sheet(isPresented: $showLocationPicker) {
//                                LocationPickerView { locationItem in
//                                    print(locationItem)
//                                }.frame(minHeight: 200)
                                NavigationView {
                                    LocationPickerView(currentLocation: currentLocation) { locationItem in
                                        selectedLocationItem = locationItem
                                    }
                                    .toolbar {
                                        ToolbarItem(placement: .navigationBarLeading) {
                                            Button("Cancel") {
                                                showLocationPicker = false
                                            }
                                        }
                                        ToolbarItem(placement: .navigationBarTrailing) {
                                            Button("OK") {
                                                showLocationPicker = false
                                                if selectedLocationItem == nil {
                                                    return
                                                }
                                                var coordinate = CLLocationCoordinate2D()
                                                coordinate.latitude = selectedLocationItem!.coordinate!.latitude
                                                coordinate.longitude = selectedLocationItem!.coordinate!.longitude
                                                location.coordinate = coordinate
                                                location.locationName = selectedLocationItem!.name
                                            }
                                        }
                                    }
                                }
                                
                            }.foregroundColor(.blue)
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                    
                    Divider()
                    Text("Description:")
                        .padding(.bottom, 10)
                    TextField("Description", text: $description, axis: .vertical)
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
                HStack {
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Cancel")
                    }
                    Button(action: { /*delete func here */
                        modelData.deleteEvent(id:event.id)
                    }) {
                    Text("Delete")
                            .foregroundColor(.red)
                    }
                },
            trailing:
                HStack {
                    Button(action: { modelData.addEventToCalendar(event: event) }) {
                        Text("Add to Calendar")
                    }
                    Button(action: { saveEvent(event: event) }) {
                        Text("Save")
                    }
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
