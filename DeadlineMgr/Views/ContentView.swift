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
            Text("Settings").tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }.task {
            WatchChannel.shared.push(action: .hello, message: ["msg": "hello world from ios"])
            WatchChannel.shared.registerReceiver(receiveAction: .hello) { msg, _ in
                print("received!", msg)
            }
            WatchChannel.shared.registerReceiver(receiveAction: .update_complete_status) { msg, _ in
                let eventId = msg["id"] as! String
                let isCompleted = msg["isCompleted"] as! Bool
                modelData.dataBase[eventId]!.isCompleted = isCompleted
            }
            // print(Firebase.shared.user)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
