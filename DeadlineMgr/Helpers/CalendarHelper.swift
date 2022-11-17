//
//  CalendarHelper.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import Foundation

class CalendarHelper {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    func monthYearString(_ date: Date) -> String{
        dateFormatter.dateFormat = "MMMM yy"
        return dateFormatter.string(from:date)
        
//        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func plusMonth(_ date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(_ date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func daysCountInMonth(_ date: Date) -> Int {
        let range = calendar.range(of:.day, in: .month, for:date)!
        return range.count
    }
    
    func dayOfMonth(_ date: Date) -> Int {
        let componets = calendar.dateComponents([.day], from: date)
        return componets.day!
    }
    
    func firstDayInMonth(_ date: Date) -> Date {
        let componets = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from:componets)!
    }
    
    func weekDay(_ date: Date) -> Int {
        let componets = calendar.dateComponents([.weekday], from: date)
        return componets.weekday! - 1
    }
    
}
