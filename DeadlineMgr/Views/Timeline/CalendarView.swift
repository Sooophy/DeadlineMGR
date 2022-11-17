//
//  CalendarView.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI


struct CalendarView: View {
    @State var date:Date = Date()
    
    var body: some View {
        VStack(spacing:1) {
            CalendarTitle(date: $date)
            //will add environment object later
                .padding()
            dayOfWeekStack
            calendarGrid
        }
        
    }
    
    var dayOfWeekStack: some View {
        HStack(){
            Text("Sun").dayOfWeek()
            Text("Mon").dayOfWeek()
            Text("Tue").dayOfWeek()
            Text("Wed").dayOfWeek()
            Text("Thu").dayOfWeek()
            Text("Fri").dayOfWeek()
            Text("Sat").dayOfWeek()
        }
    }
    
    var calendarGrid: some View {
        VStack(spacing: 2){
            
            let daysCountInMonth = CalendarHelper().daysCountInMonth(date)
            let firstDayInMonth = CalendarHelper().firstDayInMonth(date)
            let startingSpace = CalendarHelper().weekDay(firstDayInMonth)
            let prevMonth = CalendarHelper().minusMonth(date)
            let daysCountLastMonth = CalendarHelper().daysCountInMonth(prevMonth)
            
            ForEach(0..<5){
                row in
                HStack{
                    ForEach(1..<8) {
                        column in
                        let count = column + row * 7
                        CalendarCell(date: $date, count: count, startingSpace: startingSpace, daysCountInMonth: daysCountInMonth, daysCountprevMonth: daysCountLastMonth)
                    }
                }
            }
        }
        .frame(maxHeight:.infinity) // to fill the screen
    }
}

extension Text {
    func dayOfWeek() -> some View{
        self.frame(maxWidth:.infinity)
            .padding(.top, 1)
            .lineLimit(1)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
