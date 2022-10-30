//
//  Event.swift
//  DeadlineMgr
//
//  Created by Loaner on 10/30/22.
//

import Foundation
import SwiftUI

enum Source : String, Codable {
    case Default
    case Sakai
}

struct Event : Identifiable {
    var id : String = ""
    var title : String = ""
    var createdAt : Date
    var dueAt : Date
    var completedAt: Date?
    var tag : [String] = []
    var description : String = ""
    var location : String = ""
    var isCompleted : Bool = false
    var isdeleted : Bool = false
    var source : Source
    var sourceUrl : String?
    var sourceId : String?
    var color : Color?
    
    init() {
        self.id = UUID().uuidString
        self.createdAt = Date()
        self.dueAt = Calendar.current.startOfDay(for: Date()) + 86399
        self.source = .Default
    }
    
    init(title: String,
         dueAt: Date?,
         description: String,
         location: String,
         source: Source,
         sourceUrl: String?,
         sourceId: String?,
         color: Color?) {
        self.id = UUID().uuidString
        self.title = title
        self.createdAt = Date()
        self.dueAt = dueAt ?? Calendar.current.startOfDay(for: Date()) + 86399
        self.description = description
        self.location = location
        self.source = source
        self.sourceUrl = sourceUrl
        self.sourceId = sourceId
        self.color = color ?? .blue
    }
}
