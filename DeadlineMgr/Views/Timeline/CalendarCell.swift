//
//  CalendarCell.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI


struct CalendarCell: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var date:Date
//    @State var date:Date = Date()
    
    var filteredEvents : [Event] {
        filterEvents(date: getCellDate())
    }
    
    let count:Int
    let startingSpace : Int
    let daysCountInMonth : Int
    let daysCountprevMonth : Int
    
    var body: some View {
        VStack {
            Text(monthStruct().day())
                .foregroundColor(textColor(type: monthStruct().monthType))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height:10)
            
//            Button(action: {let cellDate = getCellDate()}, label: {Text("test")})
            
            VStack(alignment: .leading) {
                ForEach(filteredEvents){tempEvent in
                CalendarEventCell(event:tempEvent)
//                        .onAppear(){
//                            print(tempEvent)
//                        }
                }
                Spacer()
            }
        }
    }
    
    
    func filterEvents(date:Date)-> [Event] {
        var filteredEvents : [Event] = []
        for (_, tempEvent) in modelData.dataBase {
            let toDate = Calendar.current.startOfDay(for: tempEvent.dueAt)
            let fromDate = Calendar.current.startOfDay(for: date)
            let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
            //            print(numberOfDays.day!) as Any
            if numberOfDays.day! == 0 {
                filteredEvents.append(tempEvent)
            }
        }
        return  filteredEvents
    }
    
    func textColor(type: MonthType) -> Color {
        // this month is black, other gray
        return type == MonthType.Current ? Color.black : Color.gray
    }
    
    func monthStruct() -> MonthStruct {
        let start = startingSpace == 0 ? startingSpace + 7 : startingSpace
        if(count <= start) {
            // fill with date in prev month
            let day = daysCountprevMonth + count - start
            return MonthStruct(monthType: MonthType.Previous, dayInt: day)
        }
        else if(count - start > daysCountInMonth) {
            // fill with date in next month
            let day =  count - start - daysCountInMonth
            return MonthStruct(monthType: MonthType.Next, dayInt: day)
        }
        let day = count - start
        return MonthStruct(monthType: MonthType.Current, dayInt: day)
    }
    
    func getCellDate() -> Date {
        var tempDate = date
        var day:Int = 0
        let start = startingSpace == 0 ? startingSpace + 7 : startingSpace
        if(count <= start) {
            // fill with date in prev month
//            print("previous month")
            day = daysCountprevMonth + count - start
            tempDate = CalendarHelper().minusMonth(tempDate)
        }
        else if(count - start > daysCountInMonth) {
//            print("next month")
            // fill with date in next month
            day =  count - start - daysCountInMonth
            tempDate = CalendarHelper().plusMonth(tempDate)
        }
        else{
//            print("current month")
            day = count - start
        }
//        let cellDate = Calendar.current.date(bySetting: .day, value: day, of: tempDate) ?? Date()
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second, .month, .year], from: tempDate)

        dateComponents.day = day

        let cellDate = Calendar.current.date(from: dateComponents) ?? Date()
//        print(cellDate)
        return cellDate
    }
    
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCell(date: .constant(Date()), count: 6, startingSpace: 5, daysCountInMonth: 31, daysCountprevMonth: 30)
    }
}
