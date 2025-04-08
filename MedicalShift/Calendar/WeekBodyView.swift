//
//  WeekBodyView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/08.
//

import SwiftUI

struct WeekBodyView<Content>: View where Content: View {
    let date: Date
    let content: (_ date: Date) -> Content

    public init(
        date: Date = Date.now,
        @ViewBuilder content: @escaping (_ date: Date) -> Content
    ) {
        self.date = date
        self.content = content
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(date.weekDates, id: \.self) { d in
                content(d)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview("Weekday Symbols") {
    WeekBodyView { date in
        Text(date.weekdaySymbol(.veryShort))
            .font(.system(size: 12, weight: .light))
    }
}

#Preview("Calendar Header") {
    let yearMonth = Date.now
    
    WeekBodyView { date in
        if date.weekday == yearMonth.startOfMonth.weekday {
            VStack {
                Text(yearMonth.formatted(.dateTime.year()))
                    .font(.system(size: 12, weight: .bold))
                Text(yearMonth.formatted(.dateTime.month()))
                    .font(.system(size: 24, weight: .bold))
            }
            .foregroundStyle(yearMonth.isSameYearMonth(Date.now) ? .accentColor : Color.primary)
        } else {
            Spacer()
        }
    }
}
