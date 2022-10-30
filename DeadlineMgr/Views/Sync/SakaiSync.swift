//
//  SakaiSync.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/10/29.
//

import SwiftUI

struct SakaiSync: View {
    @StateObject var sakaiStore: SakaiStore
    @State var isLoginModalShow = false

    init() {
        self._sakaiStore = StateObject(wrappedValue: SakaiStore.shared)
    }

    var cookiesStr: String {
        sakaiStore.cookies.map { key, value in "\(key):\(value)" }.reduce("") { partialResult, s in
            partialResult + "; " + s
        }
    }

    var statusStr: String {
        "Status:" + ""
    }

    var body: some View {
        VStack {
            Text(cookiesStr)
            Button("Auth") {
                isLoginModalShow = true
            }
        }.navigationTitle("Sync").navigationBarTitleDisplayMode(.large)

            .sheet(isPresented: $isLoginModalShow, content: {
                SakaiAuth(isModalShow: $isLoginModalShow)
            })
    }
}

struct SakaiSync_Previews: PreviewProvider {
    static var previews: some View {
        SakaiSync()
    }
}
