//
//  CalendarHeaderView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct CalendarHeaderView<Content>: View where Content: View {
    enum SymbolAlignment {
        case startOfMonth
        case center
        case leading
        case trailing
    }
    private let yearMonth: Date
    private let alignment: SymbolAlignment
    let content: () -> Content

    public init(
        yearMonth: Date,
        alignment: SymbolAlignment = .startOfMonth,
        @ViewBuilder content: @escaping () ->
            Content
    ) {
        self.yearMonth = yearMonth
        self.alignment = alignment
        self.content = content
    }
    var body: some View {
        switch alignment {
        case .startOfMonth:
            HStack(spacing: 0) {
                ForEach(1...Calendar.current.weekdaySymbols.count, id: \.self) { i in
                    if i == yearMonth.startOfMonth.weekday {
                        content()
                            .frame(maxWidth: .infinity)
                    } else {
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        case .center:
            content()
                .frame(maxWidth: .infinity)
        case .leading:
            content()
                .frame(maxWidth: .infinity, alignment: .leading)
        case .trailing:
            content()
                .frame(maxWidth: .infinity, alignment: .trailing)

        }
    }
}

#Preview("startOfMonth") {
    let yearMonth = Date()
    CalendarHeaderView(yearMonth: yearMonth) {
        VStack {
            Text(yearMonth.formatted(.dateTime.year()))
                .font(.system(size: 12, weight: .bold))
            Text(yearMonth.formatted(.dateTime.month()))
                .font(.system(size: 24, weight: .bold))
        }
    }
}

#Preview("center") {
    let yearMonth = Date()
    CalendarHeaderView(yearMonth: yearMonth, alignment: .center) {
        VStack {
            Text(yearMonth.formatted(.dateTime.year()))
                .font(.system(size: 12, weight: .bold))
            Text(yearMonth.formatted(.dateTime.month()))
                .font(.system(size: 24, weight: .bold))
        }
    }
}

#Preview("leading") {
    let yearMonth = Date()
    CalendarHeaderView(yearMonth: yearMonth, alignment: .leading) {
        VStack {
            Text(yearMonth.formatted(.dateTime.year()))
                .font(.system(size: 12, weight: .bold))
            Text(yearMonth.formatted(.dateTime.month()))
                .font(.system(size: 24, weight: .bold))
        }
    }
}

#Preview("trailing") {
    let yearMonth = Date()
    CalendarHeaderView(yearMonth: yearMonth, alignment: .trailing) {
        VStack {
            Text(yearMonth.formatted(.dateTime.year()))
                .font(.system(size: 12, weight: .bold))
            Text(yearMonth.formatted(.dateTime.month()))
                .font(.system(size: 24, weight: .bold))
        }
    }
}
