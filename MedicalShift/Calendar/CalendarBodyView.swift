//
//  CalendarBodyView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct CalendarBodyView<Content>: View where Content: View {
    let month: Date
    let content: (_ day: Date) -> Content
    public init(
        month: Date,
        @ViewBuilder content: @escaping (_ day: Date) -> Content
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
            ForEach(month.calnedarDates, id: \.self) { day in
                content(day)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    let month = Date()
    CalendarBodyView(month: month) { day in
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
        .opacity(day.isSameMonth(month) ? 1 : 0.4)
    }
}
