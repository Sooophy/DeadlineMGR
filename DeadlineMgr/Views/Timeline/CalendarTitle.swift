//
//  CalendarTitle.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI

struct CalendarTitle: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    // Use today as example
//    @State var date = Date()
    
    var body: some View {
        HStack {
            Button(action: prevMonth){
                Image(systemName: "chevron.left")
                    .fontWeight(.bold)
                    .font(.title)
            }
            
            Text(CalendarHelper().monthYearString(dateHolder.date))
                .font(.title)
            
            Button(action: nextMonth){
                Image(systemName: "chevron.right")
                    .fontWeight(.bold)
                    .font(.title)
            }
        }
    }
    
    func prevMonth(){
        // go to last month
        dateHolder.date = CalendarHelper().minusMonth(dateHolder.date)
    }
    func nextMonth(){
        // go to next month
        dateHolder.date = CalendarHelper().plusMonth(dateHolder.date)
    }
}

struct CalendarTitle_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTitle()
    }
}
