//
//  Calendar2UIView.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/1.
//

import CalendarKit
import Foundation
import SwiftUI

struct Calendar2CalendarView: View, UIViewRepresentable {
    func makeUIView(context: Context) -> DayView {
        DayViewController().dayView
    }

    func updateUIView(_ uiView: DayView, context: Context) {}
}
