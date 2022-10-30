//
//  ContentView.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/10/29.
//

import SwiftUI

struct ContentView: View {
    @State var tabSelection: Int = 1

    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection) {
                Text("Events").tabItem {
                    Image(systemName: "list.dash")
                    Text("Events")
                }.tag(1)
                Text("Calendar").tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")

                }.tag(2)
                SakaiSync().tabItem {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("Sync")
                }.tag(3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
