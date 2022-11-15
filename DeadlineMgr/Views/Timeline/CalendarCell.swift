//
//  CalendarCell.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import SwiftUI

struct CalendarCell: View {
    @Binding var date:Date
    let count:Int
    let startingSpace : Int
    let daysCountInMonth : Int
    let daysCountprevMonth : Int
    
    var body: some View {
        VStack {
            Text(monthStruct().day())
                .foregroundColor(textColor(type: monthStruct().monthType))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Image(systemName: "phone.bubble.left.fill")// will be replaced by event cell
        }
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
    
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCell(date: .constant(Date()),count: 6, startingSpace: 5, daysCountInMonth: 31, daysCountprevMonth: 30)
    }
}
