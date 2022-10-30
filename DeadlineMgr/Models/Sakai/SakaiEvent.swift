//
//  SakaiEvent.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/10/29.
//

import Foundation

struct SakaiEvent: Codable {
    var id: String
    var title: String
    var url: String
    var dueDate: Date
    var openDate: Date
}
