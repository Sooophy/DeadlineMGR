//
//  SakaiStore.swift
//  deadline_manager
//
//  Created by Tianjun Mo on 2022/10/18.
//

import Foundation

class SakaiStore: ObservableObject {
    static let shared: SakaiStore = .init()
    @Published var cookies: [String: String] = [:]

    private init() {}

    func getAllSites() async -> [SakaiSite] {
        return []
    }

    func getEventBySite(site_id: String) async -> [SakaiEvent] {
        return []
    }
}
