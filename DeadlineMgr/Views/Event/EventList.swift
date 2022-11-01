//
//  EventList.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI

struct EventList: View {
    
    @EnvironmentObject var modelData: ModelData
    var currentEvents : [[Event]] {filterTodayEvents()}
    
    var body: some View {
        NavigationView {
            List(){
                Section(header: Text("Today")){
                    ForEach(currentEvents[0]) { event in
                        NavigationLink(destination: EventDetail()) {
                            EventRow()
                        }
                    }
                }
                Section(header: Text("Due in 3 days")){
                    ForEach(currentEvents[1]) { event in
                        NavigationLink(destination: EventDetail()) {
                            EventRow()
                        }
                    }
                }
                Section(header: Text("Due in a week")){
                    ForEach(currentEvents[2]) { event in
                        NavigationLink(destination: EventDetail()) {
                            EventRow()
                        }
                    }
                }
                Button(action: {
                    for (_, tempEvent) in modelData.dataBase {
                        print("\(tempEvent.dueAt)")
                    }
                }, label: {
                    Text("a")
                })
            }
        }
    }
    
    
    func filterTodayEvents() -> [[Event]]{
        let current = Date()
//        let current = 1667361599
        var currentEvents:[[Event]] = [[],[],[]]
        
        for (_, tempEvent) in modelData.dataBase {
            print("\(tempEvent.dueAt)")
            let dateDiff = Calendar.current.dateComponents([.month], from: tempEvent.dueAt, to: current)
            if dateDiff.day == 0{
                currentEvents[0].append(tempEvent)
            }
            if dateDiff.day == 3{
                currentEvents[1].append(tempEvent)
            }
            if dateDiff.day == 7{
                currentEvents[2].append(tempEvent)
            }
        }
        return currentEvents
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList().environmentObject(ModelData())
    }
}
