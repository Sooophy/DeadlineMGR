//
//  ContentView.swift
//  DeadlineMgr_watch Watch App
//
//  Created by Tianjun Mo on 2022/11/16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    var body: some View {
        VStack {
            EventList()
        }.task {
            WatchChannel.shared.push(action: .hello, message: ["msg": "hello from watch"])
            WatchChannel.shared.registerReceiver(receiveAction: .hello) { msg, _ in
                print("received!", msg)
            }
            WatchChannel.shared.registerReceiver(receiveAction: .sync) { data, _ in
                let decoder = JSONDecoder()
                let event = try! decoder.decode(Event.self, from: data["json"] as! Data)
                if let existingEvent = modelData.dataBase[event.id] {
                    if existingEvent.lastUpdate >= event.lastUpdate {
                        return
                    }
                }
                print("sync event:", event.id)
                modelData.dataBase[event.id] = event
                modelData.saveData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
