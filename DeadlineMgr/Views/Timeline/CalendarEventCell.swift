//
//  CalendarEventCell.swift
//  DeadlineMgr
//
//  Created by Sophie on 11/15/22.
//

import SwiftUI

struct CalendarEventCell: View {
    @EnvironmentObject var modelData: ModelData
    var event:Event
    var body: some View {
        Text(event.title)
            .background(event.color)
        
    }
    
}

struct CalendarEventCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarEventCell(event: ModelData().dataBase["C8F55DF8-BE79-451E-8F66-9318CA0A686C"]!)
    }
}
