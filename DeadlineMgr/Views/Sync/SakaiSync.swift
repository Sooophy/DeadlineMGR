//
//  SakaiSync.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/10/29.
//

import SwiftUI

struct SakaiSync: View {
    @EnvironmentObject var modelData: ModelData
    @StateObject var sakaiStore: SakaiStore
    @State var isLoginModalShow = false
    @State var isDetailWebView = false
    @State var showingEvent: SakaiEvent? = nil

    init() {
        self._sakaiStore = StateObject(wrappedValue: SakaiStore.shared)
    }

    var body: some View {
        NavigationView {
            ZStack {
                if sakaiStore.user == nil {
                    VStack {
                        Text("Please Authenticate Sakai to Sync Deadlines.")
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

                                    NavigationLink(destination: SakaiDetail(event.url)) {
                                        VStack(alignment: .leading) {
                                            Text(event.title)
                                            Text("Due: \(event.dueDate.formatted(date: .abbreviated, time: .shortened))").font(.caption2).multilineTextAlignment(.leading).foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                        Button {
                            modelData.processSakaiEvent()
                        } label: {
                            Text("Sync sakai event to local database")
                        }
                        // Strange warning "Publishing changes from within view updates"
                        // Solution from https://developer.apple.com/forums/thread/711899
                        .buttonStyle(BorderlessButtonStyle())
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
