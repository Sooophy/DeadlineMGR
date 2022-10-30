//
//  EventRow.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI

struct EventRow: View {
    var body: some View {
        HStack(spacing:8) {
//            add checkmark when comleted
//            Image(systemName: event.isComplete ? "checkmark.square" : "square")
            Image(systemName: "checkmark.square")
                .foregroundColor(.blue) // will be event.color ?? .black
            
            VStack(alignment: .leading, spacing: 2) {
                Text("564 Project sprint1")
                    .fontWeight(.bold)

//                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                Text("Nov 02, 2022, 13:45")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
        }
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow()
    }
}
