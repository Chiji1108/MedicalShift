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
    private let month: Date
    private let alignment: SymbolAlignment
    let content: () -> Content

    public init(
        month: Date,
        alignment: SymbolAlignment = .startOfMonth,
        @ViewBuilder content: @escaping () ->
            Content
    ) {
        self.month = month
        self.alignment = alignment
        self.content = content
    }
    var body: some View {
        switch alignment {
        case .startOfMonth:
            HStack(spacing: 0) {
                ForEach(1...7, id: \.self) { i in
                    if i == month.startOfMonth.weekday {
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
    let month = Date()
    CalendarHeaderView(month: month) {
        Text(month.formatted(.dateTime.month()))
            .font(.system(size: 24, weight: .bold))
    }
}

#Preview("center") {
    let month = Date()
    CalendarHeaderView(month: month, alignment: .center) {
        Text(month.formatted(.dateTime.month()))
            .font(.system(size: 24, weight: .bold))
    }
}

#Preview("leading") {
    let month = Date()
    CalendarHeaderView(month: month, alignment: .leading) {
        Text(month.formatted(.dateTime.month()))
            .font(.system(size: 24, weight: .bold))
    }
}

#Preview("trailing") {
    let month = Date()
    CalendarHeaderView(month: month, alignment: .trailing) {
        Text(month.formatted(.dateTime.month()))
            .font(.system(size: 24, weight: .bold))
    }
}
