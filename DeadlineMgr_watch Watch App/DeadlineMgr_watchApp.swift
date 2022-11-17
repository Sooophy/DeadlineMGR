//
//  DeadlineMgr_watchApp.swift
//  DeadlineMgr_watch Watch App
//
//  Created by Tianjun Mo on 2022/11/16.
//

import SwiftUI

@main
struct DeadlineMgr_watch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ModelData())
        }
    }
}
