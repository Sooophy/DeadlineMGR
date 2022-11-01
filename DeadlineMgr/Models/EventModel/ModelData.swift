//
//  ModelData.swift
//  DeadlineMgr
//
//  Created by Loaner on 10/30/22.
//

import Foundation


final class ModelData: ObservableObject {
    @Published var dataBase : [String: Event] = [:]
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("events")
    
    init() {
        loadData()
    }
    
    func saveData(){
        var outputData = Data()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Array(dataBase.values)) {
            if let _ = String(data: encoded, encoding: .utf8) {
                outputData = encoded
            }
            else {
                return
            }
                
            do {
                try outputData.write(to: ModelData.ArchiveURL)
            } catch let error as NSError {
                print (error)
            }
        }
    }
    
    func loadData() {
        let decoder = JSONDecoder()
        let tempData: Data
                
        do {
            //Try to load from ArchiveURL
            tempData = try Data(contentsOf: ModelData.ArchiveURL)
        } catch {
            print("First time load")
            saveData()
            return
        }
        
        if let decoded = try? decoder.decode([Event].self, from: tempData) {
            let eventArray = decoded.filter {
                $0.id != "badData"
            }
            for event in eventArray {
                dataBase[event.id] = event
            }
        }
    }
    
    func addEvent(event: Event) {
        dataBase[event.id] = event
    }
}
