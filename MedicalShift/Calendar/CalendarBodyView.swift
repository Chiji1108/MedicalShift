//
//  CalendarBodyView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct CalendarBodyView<Content>: View where Content: View {
    let month: Date
    let content: (_ day: Date, _ isCurrentMonth: Bool) -> Content
    public init(
        month: Date,
        @ViewBuilder content: @escaping (_ day: Date, _ isCurrentMonth: Bool) -> Content
    ) {
        self.month = month
        self.content = content
    }

    var body: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: 0),
                count: Calendar.current.weekdaySymbols.count
            ), spacing: 0
        ) {
            ForEach(month.datesInCalendarMonth, id: \.self) { day in
                content(day, day.isInSameMonth(as: month))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    CalendarBodyView(month: Date()) { day, isCurrentMonth in
        ZStack {
            if day.isToday {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.2))
            }

            Text("\(day.day)")
                .font(.system(size: 12, weight: .light))
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 80)
        .opacity(isCurrentMonth ? 1 : 0.4)
    }
}
