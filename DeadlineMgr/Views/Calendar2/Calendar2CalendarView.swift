//
//  Calendar2UIView.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/1.
//

import CalendarKit
import Foundation
import SwiftUI

struct Calendar2CalendarView: View, UIViewRepresentable {
    @Binding var date: Date
    var events: [Event]
    var ckEvents: [CalendarKit.EventDescriptor] {
        events.filter {
            event in
            Calendar.current.isDate(date, inSameDayAs: event.dueAt)
        }.map { event in
            let ckEvent = CalendarKit.Event()
            ckEvent.dateInterval = DateInterval(start: event.dueAt, duration: TimeInterval(60 * 24))
            ckEvent.text = event.title
            return ckEvent
        }
    }

    var dataSource: DataSource?
    
    init(date: Binding<Date>, events: [Event]) {
        self._date = date
        self.events = events
        self.dataSource = DataSource(events: events)
    }

    func makeUIView(context: Context) -> DayView {
        let dayView = DayViewController().dayView
        dayView.delegate = context.coordinator
        dayView.dataSource = dataSource
        dayView.reloadData()
        
        return dayView
    }
    
    class DataSource: EventDataSource {
        var events: [Event]
        init(events: [Event]) {
            self.events = events
        }

        func eventsForDate(_ date: Date) -> [CalendarKit.EventDescriptor] {
            let mapped = events.filter {
                event in
                Calendar.current.isDate(date, inSameDayAs: event.dueAt)
            }.map { event in
                let ckEvent = CalendarKit.Event()
                ckEvent.dateInterval = DateInterval(start: event.dueAt.addingTimeInterval(TimeInterval(-3600)), duration: TimeInterval(3600))
                ckEvent.text = event.title
                ckEvent.color = UIColor(event.color)
                return ckEvent
            }
            
            return mapped
        }
    }

    func updateUIView(_ uiView: DayView, context: Context) {
        uiView.move(to: date)
        uiView.reloadData()
    }
    
    final class Coordinator: NSObject, DayViewDelegate {
        @Binding var date: Date
        
        init(date: Binding<Date>) {
            self._date = date
        }
        
        func dayViewDidLongPressEventView(_ eventView: CalendarKit.EventView) {}
        
        func dayView(dayView: CalendarKit.DayView, didTapTimelineAt date: Date) {}
        
        func dayView(dayView: CalendarKit.DayView, didLongPressTimelineAt date: Date) {}
        
        func dayViewDidBeginDragging(dayView: CalendarKit.DayView) {}
        
        func dayViewDidTransitionCancel(dayView: CalendarKit.DayView) {}
        
        func dayView(dayView: CalendarKit.DayView, willMoveTo date: Date) {}
        
        func dayView(dayView: CalendarKit.DayView, didMoveTo date: Date) {
            self.date = date
            dayView.reloadData()
        }
        
        func dayView(dayView: CalendarKit.DayView, didUpdate event: CalendarKit.EventDescriptor) {}
        
        func dayViewDidSelectEventView(_ eventView: EventView) {}
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(date: $date)
    }
}

extension DayViewController {
    func eventsForDate(_ date: Date) -> [EventDescriptor] {
        print("evnets")
        return []
    }
}
