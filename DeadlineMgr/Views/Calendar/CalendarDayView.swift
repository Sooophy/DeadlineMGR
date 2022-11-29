//
//  Calendar2UIView.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/1.
//

import CalendarKit
import Foundation
import SwiftUI

struct CalendarDayView: View, UIViewRepresentable {
    @Binding var date: Date
    var events: [Event]

    var dataSource: DataSource?
    
    var eventTappedCallback: ((String) -> Void)?
    
    init(date: Binding<Date>, events: [Event], eventTappedCallback: ((String) -> Void)?) {
        self._date = date
        self.events = events
        self.dataSource = DataSource(events: events)
        self.eventTappedCallback = eventTappedCallback
    }

    func makeUIView(context: Context) -> DayView {
        let dayView = DayViewController().dayView
        dayView.delegate = context.coordinator
        dayView.dataSource = dataSource
        dayView.autoScrollToFirstEvent = true
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
                Calendar.current.isDate(date, inSameDayAs: event.dueAt) && !event.isDeleted
            }.map { event in
                let ckEvent = CalendarKit.Event()
                ckEvent.dateInterval = DateInterval(start: event.dueAt.addingTimeInterval(TimeInterval(-3600)), duration: TimeInterval(3600))
                ckEvent.text = event.title
                ckEvent.color = UIColor(event.color)
                ckEvent.userInfo = ["id": event.id]
                return ckEvent
            }
            
            return mapped
        }
    }

    func updateUIView(_ uiView: DayView, context: Context) {
        uiView.move(to: date)
        let dataSource = DataSource(events: events)
        uiView.dataSource = dataSource
        uiView.reloadData()
    }
    
    final class Coordinator: NSObject, DayViewDelegate {
        @Binding var date: Date
        var eventTappedCallback: ((String) -> Void)?
        
        init(date: Binding<Date>, eventTappedCallback: ((String) -> Void)?) {
            self._date = date
            self.eventTappedCallback = eventTappedCallback
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
        
        func dayViewDidSelectEventView(_ eventView: EventView) {
            let tappedEventId = ((eventView.descriptor as! CalendarKit.Event).userInfo as! [String: String])["id"]!
            if eventTappedCallback != nil { eventTappedCallback!(tappedEventId) }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(date: $date, eventTappedCallback: eventTappedCallback)
    }
}
