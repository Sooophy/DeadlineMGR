//
//  EventList.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI

struct EventList: View {
    var body: some View {
        List{
            Section(header: Text("Today")){
                EventRow()
                EventRow()
                EventRow()
                EventRow()
            }
            Section(header: Text("In 3 days")){
                EventRow()
                EventRow()
                EventRow()

            }
            Section(header: Text("In a week")){
                EventRow()
            }
        }
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
    }
}
