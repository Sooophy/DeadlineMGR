//
//  Settings.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/21.
//

import FirebaseAuth
import SwiftUI

struct Settings: View {
    @StateObject var firebaseStore: FirebaseStore
    var user: User? {
        firebaseStore.user
    }

    init() {
        self._firebaseStore = StateObject(wrappedValue: FirebaseStore.shared)
    }

    var body: some View {
        NavigationView {
            List {
                UserRow(user: user)
                HStack {
                    Text("Remind before:") // TODO: add global settings
                }
            }.navigationTitle("Settings")
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
