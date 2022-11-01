//
//  DeadlineMgrApp.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/10/29.
//

import SwiftUI

@main
struct DeadlineMgrApp: App {
    @StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
