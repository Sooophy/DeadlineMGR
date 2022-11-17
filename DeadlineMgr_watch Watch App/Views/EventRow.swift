//
//  EventRow.swift
//  DeadlineMgr_watch Watch App
//
//  Created by Tianjun Mo on 2022/11/17.
//

import SwiftUI

struct EventRow: View {
    var event: Event
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: event.isCompleted ? "checkmark.square" : "square")
                .foregroundColor(.blue) // will be event.color ?? .blue

            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .fontWeight(.bold)

                Text(event.dueAt.formatted(date: .abbreviated, time: .shortened))
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
