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
                .padding(.bottom, 40)
//            Spacer()
            calendarGrid
        }
        
    }
    
    var dayOfWeekStack: some View {
        HStack(){
            Text("Sun").fontWeight(.black).dayOfWeek()
            Text("Mon").fontWeight(.black).dayOfWeek()
            Text("Tue").fontWeight(.black).dayOfWeek()
            Text("Wed").fontWeight(.black).dayOfWeek()
            Text("Thu").fontWeight(.black).dayOfWeek()
            Text("Fri").fontWeight(.black).dayOfWeek()
            Text("Sat").fontWeight(.black).dayOfWeek()
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
