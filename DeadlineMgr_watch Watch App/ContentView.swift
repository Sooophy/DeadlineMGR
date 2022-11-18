//
//  ContentView.swift
//  DeadlineMgr_watch Watch App
//
//  Created by Tianjun Mo on 2022/11/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            EventList()
        }.task {
            WatchChannel.shared.push(action: .hello, message: ["msg": "hello world from watch"])
            WatchChannel.shared.registerReceiver(receiveAction: .hello) { msg, _ in
                print("received!", msg)
            }
            // Firebase.shared.getUser()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
