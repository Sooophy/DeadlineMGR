//
//  Calendar2View.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/1.
//

import SwiftUI

struct Calendar2View: View {
    @EnvironmentObject var modelData: ModelData

    @State var selected_date: Date = .now
    @State var is_date_presented: Bool = false

    var events: [Event] {
        modelData.dataBase.values.map { event in
            event
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Calendar2CalendarView(date: $selected_date, events: events)

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

struct Calendar2View_Previews: PreviewProvider {
    static var previews: some View {
        Calendar2View().environmentObject(ModelData())
    }
}
