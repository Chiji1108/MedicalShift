//
//  CalendarBodyView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct CalendarBodyView<Content>: View where Content: View {
    let yearMonth: Date
    let content: (_ date: Date) -> Content
    public init(
        yearMonth: Date,
        @ViewBuilder content: @escaping (_ date: Date) -> Content
    ) {
        self.yearMonth = yearMonth
        self.content = content
    }

    var body: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: 0),
                count: Calendar.current.weekdaySymbols.count
            ), spacing: 0
        ) {
            ForEach(yearMonth.calnedarDates, id: \.self) { day in
                content(day)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    CalendarBodyView(yearMonth: Date.now) { date in
        Text(date.day, format: .number.grouping(.never))
            .font(.system(size: 12, weight: .light))
            .frame(maxHeight: .infinity, alignment: .top)
            .frame(height: 60)
    }
}
