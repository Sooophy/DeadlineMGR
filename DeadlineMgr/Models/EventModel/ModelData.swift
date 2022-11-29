//
//  ModelData.swift
//  DeadlineMgr
//
//  Created by Loaner on 10/30/22.
//

import EventKit
import Foundation
import SwiftUI

final class ModelData: ObservableObject {
    var lastDatabaseUpdate: Date = .distantPast
    let sakaiStore = SakaiStore.shared
    @Published var dataBase: [String: Event] = [:]
    
    var sourceIdMap: [String: String] = [:]
    
    var alarmOffset: TimeInterval = 3600 {
        didSet {
            print("alarm time offset changed")
            // Update all events in calendar
            for event in dataBase.values {
                updateEventInCalendar(event: event)
            }
        }
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("events")
    static let DefaultURL = Bundle.main.url(forResource: "DefaultEvent", withExtension: "json")!
    
    init() {
        loadData()
    }
    
    func saveData() {
        print("saved")
        var outputData = Data()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Array(dataBase.values)) {
            if let _ = String(data: encoded, encoding: .utf8) {
                outputData = encoded
            } else {
                return
            }
                
            do {
                try outputData.write(to: ModelData.ArchiveURL)
            } catch let error as NSError {
                print(error)
                return
            }
        } else {
            return
        }
    }
    
    func loadData() {
        let decoder = JSONDecoder()
        let tempData: Data
        var firstLoad = false
                
        do {
            // Try to load from ArchiveURL
            tempData = try Data(contentsOf: ModelData.ArchiveURL)
        } catch {
            do {
                // ArchiveURL not found, try to load from default JSON file
                print("First time load, try load from default JSON file")
                firstLoad = true
                tempData = try Data(contentsOf: ModelData.DefaultURL)
            } catch let error as NSError {
                print(error)
                return
            }
        }
        
        if let decoded = try? decoder.decode([Event].self, from: tempData) {
            let eventArray = decoded.filter {
                $0.id != "badData"
            }
            for event in eventArray {
                dataBase[event.id] = event
                if event.source == .Sakai {
                    sourceIdMap[event.sourceId!] = event.id
                }
            }
            
            if firstLoad {
                saveData()
                print("First time save to sandbox")
            }
        }
    }
    
    func addUpdateEvent(id: String,
                        title: String,
                        dueAt: Date?,
                        tag: String,
                        description: String,
                        location: Location?,
                        color: Color)
    {
        if dataBase[id] != nil {
            updateEvent(id: id,
                        title: title,
                        dueAt: dueAt,
                        tag: tag,
                        description: description,
                        location: location,
                        color: color)
        } else {
            addEvent(title: title,
                     dueAt: dueAt,
                     tag: tag,
                     description: description,
                     location: location,
                     color: color)
        }
        saveLocalAndRemote()
    }
    
    func eventIsCompletedToggle(id: String) {
        if dataBase[id] == nil { return }
        if dataBase[id]!.isCompleted {
            dataBase[id]!.isCompleted = false
            dataBase[id]!.completedAt = nil
        } else {
            dataBase[id]!.isCompleted = true
            dataBase[id]!.completedAt = Date()
        }
        dataBase[id]!.lastUpdate = .now
        saveLocalAndRemote()
    }
    
    func addEvent(title: String,
                  dueAt: Date?,
                  tag: String,
                  description: String,
                  location: Location?,
                  color: Color = .blue)
    {
        let newEvent = Event(title: title,
                             dueAt: dueAt,
                             tag: tag.components(separatedBy: ","),
                             description: description,
                             location: location,
                             source: .Default,
                             sourceUrl: nil,
                             sourceId: nil,
                             color: color)
        dataBase[newEvent.id] = newEvent
        saveLocalAndRemote()
    }
    
    func updateEvent(id: String,
                     title: String,
                     dueAt: Date?,
                     tag: String,
                     description: String,
                     location: Location?,
                     color: Color)
    {
        dataBase[id]!.title = title
        if dueAt != nil {
            dataBase[id]!.dueAt = dueAt!
        }
        dataBase[id]!.tag = tag.components(separatedBy: ",")
        dataBase[id]!.description = description
        dataBase[id]!.location = location
        dataBase[id]!.color = color
        dataBase[id]!.lastUpdate = .now
        updateEventInCalendar(event: dataBase[id]!)
        saveLocalAndRemote()
    }
    
    func updateLocal(database: [String: Event], updateTime: Date) {
        dataBase = database
        sourceIdMap = [:]
        for event in dataBase.values {
            if event.source == .Sakai {
                sourceIdMap[event.sourceId!] = event.id
            }
        }
        saveData()
    }
    
    func processSakaiEvent() {
        for eventList in sakaiStore.filteredEvents.values {
            for event in eventList {
                addUpdateSakaiEvent(sakaiEvent: event)
            }
        }
    }
    
    func addUpdateSakaiEvent(sakaiEvent: SakaiEvent) {
        if sourceIdMap[sakaiEvent.id] != nil {
            updateSakaiEvent(sakaiEvent: sakaiEvent)
        } else {
            addSakaiEvent(sakaiEvent: sakaiEvent)
        }
    }
    
    func addSakaiEvent(sakaiEvent: SakaiEvent) {
        let newSakaiEvent = Event(title: sakaiEvent.title,
                                  dueAt: sakaiEvent.dueDate,
                                  tag: ["Sakai"],
                                  description: "",
                                  location: nil,
                                  source: .Sakai,
                                  sourceUrl: sakaiEvent.url,
                                  sourceId: sakaiEvent.id,
                                  color: .blue)
        dataBase[newSakaiEvent.id] = newSakaiEvent
        sourceIdMap[newSakaiEvent.sourceId!] = newSakaiEvent.id
        saveLocalAndRemote()
    }
    
    func updateSakaiEvent(sakaiEvent: SakaiEvent) {
        let id = sourceIdMap[sakaiEvent.id]!
        dataBase[id]!.title = sakaiEvent.title
        dataBase[id]!.dueAt = sakaiEvent.dueDate
        dataBase[id]!.createdAt = sakaiEvent.openDate
        dataBase[id]!.lastUpdate = .now
        updateEventInCalendar(event: dataBase[id]!)
        saveLocalAndRemote()
    }
    
    // save locally and remotelly
    func saveLocalAndRemote() {
        Task {
            // debounce with 200ms
            try! await Task.sleep(nanoseconds: 200 * 1000 * 1000)
            if lastDatabaseUpdate < Date() - 0.2 {
                lastDatabaseUpdate = .now
                saveData()
                await FirebaseStore.shared.saveEvents(events: dataBase)
            }
        }
    }
    
    func addUpdateEventInCalendar(event: Event) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { _, _ in
            if event.calendarIdentifier != nil, eventStore.event(withIdentifier: event.calendarIdentifier!) != nil {
                self.updateEventInCalendar(event: event)
            } else {
                self.addEventToCalendar(event: event)
            }
        }
    }
    
    func addEventToCalendar(event: Event) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                guard granted else {
                    print("Access to calendar not granted")
                    return
                }
                if event.calendarIdentifier != nil, eventStore.event(withIdentifier: event.calendarIdentifier!) != nil {
                    print("Event already exist in calendar")
                    return
                }
                let newEKEvent = EKEvent(eventStore: eventStore)
                newEKEvent.title = event.title
                newEKEvent.startDate = event.dueAt - self.alarmOffset
                newEKEvent.endDate = event.dueAt
                newEKEvent.location = event.location?.locationName
                newEKEvent.calendar = eventStore.defaultCalendarForNewEvents
                newEKEvent.addAlarm(EKAlarm())
                do {
                    try eventStore.save(newEKEvent, span: .thisEvent)
                    if self.dataBase[event.id] != nil {
                        self.dataBase[event.id]!.calendarIdentifier = newEKEvent.eventIdentifier
                        self.saveLocalAndRemote()
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateEventInCalendar(event: Event) {
        guard event.calendarIdentifier != nil else {
            return
        }
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            guard granted else {
                print("Access to calendar not granted")
                return
            }
            if let updateEvent = eventStore.event(withIdentifier: event.calendarIdentifier!) {
                updateEvent.title = event.title
                updateEvent.startDate = event.dueAt - self.alarmOffset
                updateEvent.endDate = event.dueAt
                updateEvent.location = event.location?.locationName
                if let alarm = updateEvent.alarms?.first {
                    updateEvent.removeAlarm(alarm)
                }
                updateEvent.addAlarm(EKAlarm())
                do {
                    try eventStore.save(updateEvent, span: .thisEvent)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("Event not found in calendar")
            }
        }
    }
    
    func deleteEvent(id: String) {
        if var event = dataBase[id] {
            if event.isDeleted {
                return
            }
            dataBase[id]!.isDeleted = true
            dataBase[id]!.lastUpdate = .now
            saveLocalAndRemote()
            deleteEventFromCalendar(event: event)
        }
    }
    
    func deleteEventFromCalendar(event: Event) {
        guard event.calendarIdentifier != nil else {
            return
        }
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            guard granted else {
                print("Access to calendar not granted")
                return
            }
            if let deleteEvent = eventStore.event(withIdentifier: event.calendarIdentifier!) {
                do {
                    try eventStore.remove(deleteEvent, span: .thisEvent)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("Event not found in calendar")
            }
        }
    }
}
