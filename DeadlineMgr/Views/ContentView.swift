//
//  ContentView.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/10/29.
//

import SwiftUI

struct ContentView: View {
    @State var tabSelection: Int = 1
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        TabView(selection: $tabSelection) {
            EventList().tabItem {
                Image(systemName: "list.dash")
                Text("Events")
            }.tag(1)
            CalendarMonth().tabItem {
                Image(systemName: "calendar")
                Text("Calendar")

            }.tag(2)
            SakaiSync().tabItem {
                Image(systemName: "arrow.triangle.2.circlepath")
                Text("Sync")
            }.tag(3)
            Settings().tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }.task {
            WatchChannel.shared.push(action: .hello, message: ["msg": "hello world from ios"])
            WatchChannel.shared.registerReceiver(receiveAction: .hello) { msg, _ in
                print("received!", msg)
                let events = modelData.dataBase.values
                for event in events {
                    let json = try! JSONEncoder().encode(event)
                    WatchChannel.shared.push(action: .sync, message: ["json": json])
                }
            }
            WatchChannel.shared.registerReceiver(receiveAction: .update_complete_status) { msg, _ in
                let eventId = msg["id"] as! String
                let isCompleted = msg["isCompleted"] as! Bool
                if modelData.dataBase[eventId]!.isCompleted != isCompleted {
                    modelData.eventIsCompletedToggle(id: eventId)
                }
            }
            FirebaseStore.shared.onInitCompleted {
                FirebaseStore.shared.eventsRef?.child("data").observe(.childChanged, with: { snapshot in
                    let event = try! snapshot.data(as: Event.self)
                    let json = try! JSONEncoder().encode(event)
                    WatchChannel.shared.push(action: .sync, message: ["json": json])
                    let eventId = event.id
                    if let existingEvent = modelData.dataBase[eventId] {
                        if existingEvent.lastUpdate >= event.lastUpdate {
                            return
                        }
                    }
                    print("event changed")
                    var newDatabase = modelData.dataBase
                    newDatabase[eventId] = event
                    modelData.updateLocal(database: newDatabase, updateTime: .now)

                })
                FirebaseStore.shared.eventsRef?.child("data").observe(.childAdded, with: { snapshot in

                    let event = try! snapshot.data(as: Event.self)
                    let eventId = event.id
                    let json = try! JSONEncoder().encode(event)
                    WatchChannel.shared.push(action: .sync, message: ["json": json])
                    if let existingEvent = modelData.dataBase[eventId] {
                        if existingEvent.lastUpdate >= event.lastUpdate {
                            return
                        }
                    }
                    print("added event")
                    var newDatabase = modelData.dataBase
                    newDatabase[eventId] = event
                    modelData.updateLocal(database: newDatabase, updateTime: .now)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
