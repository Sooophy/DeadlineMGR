//
//  EventDetail.swift
//  DeadlineMgr_watch Watch App
//
//  Created by Tianjun Mo on 2022/11/17.
//

import SwiftUI

struct EventDetail: View {
    @State var event: Event
    @EnvironmentObject var modelData: ModelData

    var timeInterval: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(fromTimeInterval: Date().distance(to: event.dueAt))
    }

    var body: some View {
        List {
            TextField("Title", text: $event.title).disabled(true)
            Text("Due: " + timeInterval)
            Text(event.description).font(.caption2).foregroundColor(.gray)
            HStack {
                Image(systemName: event.isCompleted ? "checkmark.square" : "square")
                Button(event.isCompleted ? "Undo" : "Complete event") {
                    event.isCompleted.toggle()
                    modelData.dataBase[event.id]!.isCompleted.toggle()
                    WatchChannel.shared.push(action: .update_complete_status,
                                             message: [
                                                 "id": event.id,
                                                 "isCompleted": event.isCompleted,
                                             ])
                }
            }.listItemTint(event.isCompleted ? .red : .blue).multilineTextAlignment(.center)
        }
    }
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(event: ModelData().dataBase["C8F55DF8-BE79-451E-8F66-9318CA0A686C"]!).environmentObject(ModelData())
    }
}
