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

    var statusStr: String {
        "Status:" + ""
    }

//
//    let dateFormatter = dateFormatter()
//
//    func ()

    var body: some View {
        VStack {
            List {
                Group {
                    Text("User: \(sakaiStore.user?.name ?? "Not login yet")")
                    Text("Auth Status: \(sakaiStore.user != nil ? "OK" : "Not Authed")")
                    Button("Auth") {
                        isLoginModalShow = true
                    }
                    Button("Reload") {
                        sakaiStore.fetchInfo()
                    }
                }
                ForEach(sakaiStore.sites, id: \.self.id) {
                    site in
                    Section(site.title) {
                        ForEach(sakaiStore.events[site] ?? [], id: \.self.id) {
                            event in
                            VStack {
                                HStack {
                                    Text(event.title)
                                    Spacer()
                                }

                                Text("Due: \(event.dueDate.description(with: Locale.current))").font(.caption2)
                            }
                        }
                    }
                }
            }.listStyle(.insetGrouped)

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
