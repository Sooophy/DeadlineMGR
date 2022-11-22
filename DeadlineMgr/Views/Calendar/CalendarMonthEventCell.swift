//
//  CalendarEventCell.swift
//  DeadlineMgr
//
//  Created by Sophie on 11/15/22.
//

import SwiftUI

struct CalendarMonthEventCell: View {
    @EnvironmentObject var modelData: ModelData
    var event: Event
    var backgroundColor: Color {
        var brightness: CGFloat = 0
        UIColor(event.color).getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        if brightness > 0.5 {
            return .black
        }
        return .white
    }

    var body: some View {
        HStack {
            Text(event.title)
                .foregroundColor(.black)
            .font(.caption)
                .lineLimit(1)
            Spacer()
        }
        .background(event.color.opacity(0.3))
    }
}

struct CalendarEventCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMonthEventCell(event: ModelData().dataBase["C8F55DF8-BE79-451E-8F66-9318CA0A686C"]!)
    }
}
