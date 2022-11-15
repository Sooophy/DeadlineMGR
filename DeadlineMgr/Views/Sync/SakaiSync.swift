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

    var body: some View {
        NavigationView {
            ZStack {
                if sakaiStore.user == nil {
                    VStack {
                        Text("Please Authenticate Sakai to Synchronize Events.")
                        Button("Log In") {
                            isLoginModalShow = true
                        }
                    }

                } else {
                    List {
                        ForEach(sakaiStore.filteredEvents.sorted(by: { a, b in
                            a.key.id > b.key.id
                        }), id: \.self.key.id) {
                            site, events in
                            Section(site.title) {
                                ForEach(events, id: \.self.id) {
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
                        .blur(radius: sakaiStore.isLoading ? 5 : 0, opaque: sakaiStore.isLoading ? true : false).disabled(sakaiStore.isLoading)

                    sakaiStore.isLoading ? ProgressView().scaleEffect(5) : nil
                }
            }.navigationTitle("Sync")
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        if sakaiStore.user?.name != nil {
                            Menu {
                                Button {
                                    sakaiStore.deleteCookies()
                                } label: {
                                    Image(systemName: "escape")
                                    Text("Log out")
                                }
                            } label: {
                                Text("🟢 " + String(describing: sakaiStore.user!.name))
                            }

                        } else {
                            Button("🔴 Log in") {
                                isLoginModalShow = true
                            }
                        }
                        Button {
                            sakaiStore.fetchInfo()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
        }

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
