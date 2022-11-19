//
//  EventLocation.swift
//  DeadlineMgr
//
//  Created by Sophie on 11/19/22.
//

import SwiftUI
import MapKit

struct EventLocation: View {
//    var coordinate: CLLocationCoordinate2D
    @Binding var location: Location
    @State private var region = MKCoordinateRegion()
    
    
    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                setRegion()
            }
    }


    private func setRegion() {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
    }
}

struct EventLocation_Previews: PreviewProvider {
    static var previews: some View {
        EventLocation(location: .constant(Location()))
    }
}
