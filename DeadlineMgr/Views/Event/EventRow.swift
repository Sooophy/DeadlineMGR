//
//  EventRow.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI

struct EventRow: View {
    @EnvironmentObject var modelData: ModelData
    var event: Event
    var body: some View {
        HStack(spacing:8) {
//            add checkmark when comleted
            Image(systemName: event.isCompleted ? "checkmark.square" : "square")
                .onTapGesture {
//                    event.isCompleted.toggle()
                }
//            Image(systemName: "checkmark.square")
                .foregroundColor(.blue) // will be event.color ?? .blue
            
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .fontWeight(.bold)

                Text(event.dueAt.formatted(date: .abbreviated, time: .shortened))
//                Text("Nov 02, 2022, 13:45")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
        }
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow(event: ModelData().dataBase["C8F55DF8-BE79-451E-8F66-9318CA0A686C"]!)
    }
}
