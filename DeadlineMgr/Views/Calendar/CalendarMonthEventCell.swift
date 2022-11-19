//
//  CalendarEventCell.swift
//  DeadlineMgr
//
//  Created by Sophie on 11/15/22.
//

import SwiftUI

struct CalendarMonthEventCell: View {
    @EnvironmentObject var modelData: ModelData
    var event:Event
    var body: some View {
        Text(event.title)
            .background(event.color)
            .lineLimit(1)
        
    }
    
}

struct CalendarEventCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMonthEventCell(event: ModelData().dataBase["C8F55DF8-BE79-451E-8F66-9318CA0A686C"]!)
    }
}