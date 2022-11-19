//
//  ModelData.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/17.
//

import Foundation

final class ModelData: ObservableObject {
    @Published var dataBase: [String: Event] = [:]
    @Published var isLoading: Bool = false

    func fetchEvents() {
        DispatchQueue.main.async {
            Task {
                let events = await FirebaseWatch.shared.getEvents()
                self.dataBase = events
            }
        }
    }
}
