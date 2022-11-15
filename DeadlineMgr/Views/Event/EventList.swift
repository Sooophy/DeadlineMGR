//
//  EventList.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI
import Foundation

struct EventList: View {
    
    @EnvironmentObject var modelData: ModelData
    var currentEvents : [[Event]] {filterTodayEvents()}
    
    var body: some View {
        NavigationView {
            List(){
                Section(header: Text("Today")){
                    ForEach(currentEvents[0]) { event in
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRow(event:event)
                        }
                    }
                }
                Section(header: Text("Due in 3 days")){
                    ForEach(currentEvents[1]) { event in
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRow(event:event)
                        }
                    }
                }
                Section(header: Text("Due in a week")){
                    ForEach(currentEvents[2]) { event in
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRow(event:event)
                        }
                    }
                }
                Section(header: Text("Already past due")){
                    ForEach(currentEvents[3]) { event in
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRow(event:event)
                        }
                    }
                }
                
                // button for test
                Button(action: {
                    for (_, tempEvent) in modelData.dataBase {
                        print("\(tempEvent.title)")
                    }
                    print(currentEvents)
                }, label: {
                    Text("test")
                })
            }
//            List(modelData.dataBase.sorted(by: >), id: \.key) { tempEvent in
//                let toDate = Calendar.current.startOfDay(for: tempEvent.dueAt)
//                let fromDate = Calendar.current.startOfDay(for: Date())
//                let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
//
//            }
        }
    }
    
    
    func filterTodayEvents() -> [[Event]]{
        let current = Date()
//        let current = 1667361599
        var currentEvents:[[Event]] = [[],[],[],[]]
        
        for (_, tempEvent) in modelData.dataBase {
//            print("\(tempEvent.dueAt)")
//            let dateDiff = Calendar.current.dateComponents([.month], from: tempEvent.dueAt, to: current)
            let toDate = Calendar.current.startOfDay(for: tempEvent.dueAt)
            let fromDate = Calendar.current.startOfDay(for: current)
            let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
//            print(numberOfDays.day!) as Any
            if numberOfDays.day! == 0{
                currentEvents[0].append(tempEvent)
            }
            if numberOfDays.day! == 3 {
                currentEvents[1].append(tempEvent)
            }
            if numberOfDays.day! == 7{
                currentEvents[2].append(tempEvent)
            }
            if numberOfDays.day! < 0{
                currentEvents[3].append(tempEvent)
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
