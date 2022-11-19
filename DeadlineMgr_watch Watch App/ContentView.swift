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
            FirebaseWatch.shared.onInitCompleted {
                modelData.fetchEvents()
            }
            WatchChannel.shared.push(action: .hello, message: ["msg": "hello from watch"])
            WatchChannel.shared.registerReceiver(receiveAction: .hello) { msg, _ in
                print("received!", msg)
            }
            WatchChannel.shared.registerReceiver(receiveAction: .sync) { _, _ in
                modelData.fetchEvents()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
