//
//  EventList.swift
//  DeadlineMgr_watch Watch App
//
//  Created by Tianjun Mo on 2022/11/17.
//

import SwiftUI

struct EventList: View {
    @EnvironmentObject var modelData: ModelData
    var currentEvents: [[Event]] {
        let current = Date()
        var currentEvents: [[Event]] = [[], [], [], []]

        for (_, tempEvent) in modelData.dataBase {
            let toDate = Calendar.current.startOfDay(for: tempEvent.dueAt)
            let fromDate = Calendar.current.startOfDay(for: current)
            let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
            //            print(numberOfDays.day!) as Any
            if numberOfDays.day! < 0 {
                currentEvents[3].append(tempEvent)
            } else if numberOfDays.day! == 0 {
                currentEvents[0].append(tempEvent)
            } else if numberOfDays.day! <= 3 {
                currentEvents[1].append(tempEvent)
            } else if numberOfDays.day! <= 7 {
                currentEvents[2].append(tempEvent)
            }
        }
        return currentEvents
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Today")) {
                    ForEach(currentEvents[0]) { event in
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRow(event: event)
                        }
                    }
                }
                Section(header: Text("Due in 3 days")) {
                    ForEach(currentEvents[1]) { event in
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRow(event: event)
                        }
                    }
                }
                Section(header: Text("Due in a week")) {
                    ForEach(currentEvents[2]) { event in
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRow(event: event)
                        }
                    }
                }
                Section(header: Text("Already past due")) {
                    ForEach(currentEvents[3]) { event in
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRow(event: event)
                        }
                    }
                }
            }
        }
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList().environmentObject(ModelData())
    }
}
