//
//  Event.swift
//  DeadlineMgr
//
//  Created by Loaner on 10/30/22.
//

import CoreLocation
import Foundation
import SwiftUI
import EventKit

enum Source: String, Codable {
    case Default
    case Sakai
}

struct ColorCode: Codable {
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    var alpha: CGFloat
}

struct Location: Codable {
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    
    private enum CodingKeys: String, CodingKey { case locationName, latitude, longitude }
    
    init() {
        self.locationName = "N/A"
        self.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
    init(locationName: String,
         latitude: CLLocationDegrees,
         longitude: CLLocationDegrees)
    {
        self.locationName = locationName
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locationName = try container.decode(String.self, forKey: .locationName)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.locationName, forKey: .locationName)
        try container.encode(self.coordinate.latitude, forKey: .latitude)
        try container.encode(self.coordinate.longitude, forKey: .longitude)
    }
}

struct Event: Codable, Identifiable {
    var id: String
    var title: String = ""
    var createdAt: Date
    var dueAt: Date
    var lastUpdate: Date
    var completedAt: Date?
    var tag: [String] = []
    var description: String = ""
    var location: Location?
    var isCompleted: Bool = false
    var isDeleted: Bool = false
    var source: Source
    var sourceUrl: String?
    var sourceId: String?
    var color: Color = .blue
    
    private enum CodingKeys: String, CodingKey { case id, title, createdAt, dueAt, completedAt, tag, description, location, isCompleted, isDeleted, source, sourceUrl, sourceId, color, lastUpdate }
    
    init() {
        self.id = UUID().uuidString
        self.createdAt = Date()
        self.dueAt = Calendar.current.startOfDay(for: Date()) + 86399
        self.source = .Default
        self.lastUpdate = Date()
    }
    
    init(title: String,
         createdAt: Date = Date(),
         dueAt: Date?,
         tag: [String],
         description: String,
         location: Location?,
         source: Source,
         sourceUrl: String?,
         sourceId: String?,
         color: Color?)
    {
        self.id = UUID().uuidString
        self.title = title
        self.createdAt = createdAt
        self.dueAt = dueAt ?? Calendar.current.startOfDay(for: Date()) + 86399
        self.tag = tag
        self.description = description
        self.location = location
        self.source = source
        self.sourceUrl = sourceUrl
        self.sourceId = sourceId
        self.color = color ?? .blue
        self.lastUpdate = .now
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.id = try container.decode(String.self, forKey: .id)
        } catch {
            self.id = "badData"
        }
        do {
            self.title = try container.decode(String.self, forKey: .title)
        } catch {
            self.title = ""
        }
        do {
            let createdAtInterval = try container.decode(TimeInterval.self, forKey: .createdAt)
            self.createdAt = Date(timeIntervalSince1970: createdAtInterval)
        } catch {
            self.createdAt = Date()
            self.id = "badData"
        }
        do {
            let dueAtInterval = try container.decode(TimeInterval.self, forKey: .dueAt)
            self.dueAt = Date(timeIntervalSince1970: dueAtInterval)
        } catch {
            self.dueAt = Date()
            self.id = "badData"
        }
        if let completedAtInterval = try? container.decode(TimeInterval.self, forKey: .completedAt) {
            self.completedAt = Date(timeIntervalSince1970: completedAtInterval)
        }
        do {
            self.tag = try container.decode([String].self, forKey: .tag)
        } catch {
            self.tag = []
        }
        do {
            self.description = try container.decode(String.self, forKey: .description)
        } catch {
            self.description = ""
        }
        self.location = try? container.decode(Location.self, forKey: .location)
        do {
            self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        } catch {
            self.isCompleted = false
        }
        do {
            self.isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        } catch {
            self.isDeleted = false
        }
        do {
            self.source = try container.decode(Source.self, forKey: .source)
        } catch {
            self.source = .Default
            self.id = "badData"
        }
        do {
            self.sourceUrl = try container.decode(String.self, forKey: .sourceUrl)
        } catch {
            if self.source == .Sakai {
                self.id = "badData"
            }
        }
        do {
            self.sourceId = try container.decode(String.self, forKey: .sourceId)
        } catch {
            if self.source == .Sakai {
                self.id = "badData"
            }
        }
        do {
            let colorCode = try container.decode(ColorCode.self, forKey: .color)
            self.color = Color(red: colorCode.r, green: colorCode.g, blue: colorCode.b, opacity: colorCode.alpha)
        } catch {
            self.color = .blue
        }
        do {
            let lastUpdateInterval = try container.decode(TimeInterval.self, forKey: .lastUpdate)
            self.lastUpdate = Date(timeIntervalSince1970: lastUpdateInterval)
        } catch {
            self.lastUpdate = Date()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.createdAt.timeIntervalSince1970, forKey: .createdAt)
        try container.encode(self.dueAt.timeIntervalSince1970, forKey: .dueAt)
        try container.encode(self.completedAt?.timeIntervalSince1970, forKey: .completedAt)
        try container.encode(self.lastUpdate.timeIntervalSince1970, forKey: .lastUpdate)
        try container.encode(self.tag, forKey: .tag)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.isCompleted, forKey: .isCompleted)
        try container.encode(self.isDeleted, forKey: .isDeleted)
        try container.encode(self.source, forKey: .source)
        try container.encode(self.sourceUrl, forKey: .sourceUrl)
        try container.encode(self.sourceId, forKey: .sourceId)
        let uiColor = UIColor(self.color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &alpha)
        let colorCode = ColorCode(r: r, g: g, b: b, alpha: alpha)
        try container.encode(colorCode, forKey: .color)
    }
}
