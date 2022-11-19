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
    var localDocLastUpdate: Date = .distantPast
    @Published var dataBase: [String: Event] = [:]
    
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
        localDocLastUpdate = .now
        let defaults = UserDefaults.standard
        defaults.set(localDocLastUpdate, forKey: "localDocLastUpdate")
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
            }
            
            if firstLoad {
                saveData()
                print("First time save to sandbox")
            }
        }
        let defaults = UserDefaults.standard
        localDocLastUpdate = defaults.object(forKey: "localDocLastUpdate") as? Date ?? Date()
        print("localDocLastUpdate", localDocLastUpdate)
    }
    
    func addUpdatdEvent(id: String,
                        title: String,
                        dueAt: Date?,
                        tag: String,
                        description: String,
                        location: Location?,
                        source: Source,
                        sourceUrl: String?,
                        sourceId: String?,
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
                     source: source,
                     sourceUrl: sourceUrl,
                     sourceId: sourceId,
                     color: color)
        }
        save()
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
        save()
    }
    
    func addEvent(title: String,
                  dueAt: Date?,
                  tag: String,
                  description: String,
                  location: Location?,
                  source: Source,
                  sourceUrl: String?,
                  sourceId: String?,
                  color: Color)
    {
        let newEvent = Event(title: title,
                             dueAt: dueAt,
                             tag: tag.components(separatedBy: ","),
                             description: description,
                             location: location,
                             source: source,
                             sourceUrl: sourceUrl,
                             sourceId: sourceId,
                             color: color)
        dataBase[newEvent.id] = newEvent
        save()
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
        save()
    }
    
    // save locally and remotelly
    func save() {
        Task {
            // debounce with 200ms
            try! await Task.sleep(nanoseconds: 200 * 1000 * 1000)
            if lastDatabaseUpdate < Date() - 0.2 {
                lastDatabaseUpdate = Date()
                saveData()
                await Firebase.shared.saveEvents(events: dataBase)
                WatchChannel.shared.push(action: .sync)
            }
        }
    }
}
