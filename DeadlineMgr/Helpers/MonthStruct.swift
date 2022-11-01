//
//  MonthStruct.swift
//  DeadlineMgr
//
//  Created by Sophie on 10/30/22.
//

import Foundation
import SwiftUI

struct MonthStruct
{
    var monthType: MonthType
    var dayInt: Int
    func day() -> String{
        return "\(dayInt)"
//        return String(dayInt)
    }
}

enum MonthType
{
    case Previous
    case Current
    case Next
}
