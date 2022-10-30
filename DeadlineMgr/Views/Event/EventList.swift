//
//  EventList.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI

struct EventList: View {
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Today")){
                    NavigationLink(destination: EventDetail()) {
                        EventRow()
                    }
                }
                Section(header: Text("In 3 days")){
                    NavigationLink(destination: EventDetail()) {
                        EventRow()
                    }

                }
                Section(header: Text("In a week")){
                    NavigationLink(destination: EventDetail()) {
                        EventRow()
                    }
                }
            }
        }
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
    }
}
