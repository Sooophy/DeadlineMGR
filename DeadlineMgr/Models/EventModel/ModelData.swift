//
//  ModelData.swift
//  DeadlineMgr
//
//  Created by Loaner on 10/30/22.
//

import Foundation
import SwiftUI

final class ModelData: ObservableObject {
    var lastDatabaseUpdate: Date = .distantPast
    let sakaiStore = SakaiStore.shared
    @Published var dataBase: [String: Event] = [:]
    
    var sourceIdMap: [String: String] = [:]
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("events")
    static let DefaultURL = Bundle.main.url(forResource: "DefaultEvent", withExtension: "json")!
    
    init() {
        loadData()
        dataBase.values.first?.addToCalendar()
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
        saveLocalAndRemote()
    }
    
    func updateLocal(database: [String: Event], updateTime: Date) {
        self.dataBase = database
        self.sourceIdMap = [:]
        for event in self.dataBase.values {
            if event.source == .Sakai {
                sourceIdMap[event.sourceId!] = event.id
            }
        }
        saveData()
    }
    
    func processSakaiEvent() {
        print(dataBase)
        for eventList in sakaiStore.filteredEvents.values {
            for event in eventList {
                addUpdateSakaiEvent(sakaiEvent: event)
            }
        }
    }
    
    func addUpdateSakaiEvent(sakaiEvent: SakaiEvent) {
        if sourceIdMap[sakaiEvent.id] != nil {
            updateSakaiEvent(sakaiEvent: sakaiEvent)
        }
        else {
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
                await Firebase.shared.saveEvents(events: dataBase)
            }
        }
    }
}
