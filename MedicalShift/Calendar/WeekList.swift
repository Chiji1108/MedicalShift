//
//  WeekList.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct WeekList<Content>: View where Content: View {
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
        VStack {
            ForEach(weeksInCurrentMonth(), id: \.self) { weekDate in
                WeekRow(date: weekDate) { date in
                    content(date)
                }
            }
        }
    }

    // MARK: - Private Methods
    private func weeksInCurrentMonth() -> [Date] {
        (0..<yearMonth.weeksInMonth).map { weekIndex in
            Calendar.current.date(
                byAdding: .weekOfMonth,
                value: weekIndex,
                to: yearMonth.startOfMonth
            )!
        }
    }
}

#Preview {
    WeekList(yearMonth: Date.now) { date in
        Text(date.day, format: .number)
            .font(.system(size: 12, weight: .light))
            .frame(maxHeight: .infinity, alignment: .top)
    }
}
