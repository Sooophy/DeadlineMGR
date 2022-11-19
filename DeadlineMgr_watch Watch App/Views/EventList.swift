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
        var currentEvents: [[Event]] = [[], [], [], [], []]

        for (_, tempEvent) in modelData.dataBase {
            let toDate = Calendar.current.startOfDay(for: tempEvent.dueAt)
            let fromDate = Calendar.current.startOfDay(for: current)
            let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
            if numberOfDays.day! < 0 {
                currentEvents[3].append(tempEvent)
            } else if numberOfDays.day! == 0 {
                currentEvents[0].append(tempEvent)
            } else if numberOfDays.day! <= 3 {
                currentEvents[1].append(tempEvent)
            } else if numberOfDays.day! <= 7 {
                currentEvents[2].append(tempEvent)
            } else {
                // future event
                currentEvents[4].append(tempEvent)
            }

            currentEvents[0].sort(by: { ($0.dueAt, $0.id) < ($1.dueAt, $1.id) })
            currentEvents[1].sort(by: { ($0.dueAt, $0.id) < ($1.dueAt, $1.id) })
            currentEvents[2].sort(by: { ($0.dueAt, $0.id) < ($1.dueAt, $1.id) })
            currentEvents[4].sort(by: { ($0.dueAt, $0.id) < ($1.dueAt, $1.id) })
            currentEvents[3].sort(by: { ($0.dueAt, $0.id) > ($1.dueAt, $1.id) })
        }
        return currentEvents
    }

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    if !currentEvents[0].isEmpty {
                        Section(header: Text("Today")) {
                            ForEach(currentEvents[0]) { event in
                                NavigationLink(destination: EventDetail(event: event)) {
                                    EventRow(event: event)
                                }
                            }
                        }
                    }
                    if !currentEvents[1].isEmpty {
                        Section(header: Text("Due in 3 days")) {
                            ForEach(currentEvents[1]) { event in
                                NavigationLink(destination: EventDetail(event: event)) {
                                    EventRow(event: event)
                                }
                            }
                        }
                    }
                    if !currentEvents[2].isEmpty {
                        Section(header: Text("Due in a week")) {
                            ForEach(currentEvents[2]) { event in
                                NavigationLink(destination: EventDetail(event: event)) {
                                    EventRow(event: event)
                                }
                            }
                        }
                    }
                    if !currentEvents[3].isEmpty {
                        Section(header: Text("Already past due")) {
                            ForEach(currentEvents[3]) { event in
                                NavigationLink(destination: EventDetail(event: event)) {
                                    EventRow(event: event)
                                }
                            }
                        }
                    }
                    if !currentEvents[4].isEmpty {
                        Section(header: Text("Future")) {
                            ForEach(currentEvents[4]) { event in
                                NavigationLink(destination: EventDetail(event: event)) {
                                    EventRow(event: event)
                                }
                            }
                        }
                    }
                }.disabled(modelData.isLoading).blur(radius: modelData.isLoading ? 5 : 0)
                if modelData.isLoading {
                    ProgressView()
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
