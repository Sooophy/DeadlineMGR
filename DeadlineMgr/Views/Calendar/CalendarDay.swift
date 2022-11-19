//
//  CalendarDay.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/1.
//

import SwiftUI

struct CalendarDay: View {
    @EnvironmentObject var modelData: ModelData

    @State var selected_date: Date
    @State var is_date_presented: Bool = false
    @State var showing_event_id: String? = nil { didSet {
        if showing_event_id != nil {
            isShowingDetailView = true
        }
    }}
    @State var isShowingDetailView: Bool = false {
        didSet {
            if !isShowingDetailView {
                showing_event_id = nil
            }
        }
    }

    init(date: Date) {
        self._selected_date = State(wrappedValue: date)
    }

    var events: [Event] {
        modelData.dataBase.values.map { event in
            event
        }
    }

    var body: some View {
        ZStack {
            CalendarDayView(date: $selected_date, events: events, eventTappedCallback: {
                id in
                self.showing_event_id = id
            })
            NavigationLink(destination:
                EventDetail(event:
                    (self.showing_event_id != nil) ? self.modelData.dataBase[self.showing_event_id!]! : Event()), isActive: $isShowingDetailView) { EmptyView() }

        }.navigationBarTitle("Calendar", displayMode: .inline).toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    is_date_presented = true
                } label: {
                    Image(systemName: "calendar")
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Today") {
                    selected_date = .now
                }
            }

        }.sheet(isPresented: $is_date_presented) {
            DatePicker(
                selection: $selected_date,
                displayedComponents: [.date]
            ) {
                Text("date")
            }
            .datePickerStyle(.graphical)
            .presentationDetents([.height(400)])
        }
    }
}

struct CalendarDay_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDay(date: .now).environmentObject(ModelData())
    }
}
