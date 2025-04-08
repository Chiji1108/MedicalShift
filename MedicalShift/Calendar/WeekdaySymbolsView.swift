//
//  WeekdaySymbolsView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct WeekdaySymbolsView<Content>: View where Content: View {
    enum SymbolStyle {
        case full
        case short
        case veryShort

        var symbols: [String] {
            switch self {
            case .full:
                return Calendar.current.standaloneWeekdaySymbols
            case .short:
                return Calendar.current.shortStandaloneWeekdaySymbols
            case .veryShort:
                return Calendar.current.veryShortStandaloneWeekdaySymbols
            }
        }
    }

    let symbolStyle: SymbolStyle
    let content: (_ weekdaySymbol: String) -> Content
    public init(
        style: SymbolStyle = .short,
        @ViewBuilder content: @escaping (_ weekdaySymbol: String) -> Content
    ) {
        self.symbolStyle = style
        self.content = content
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(symbolStyle.symbols, id: \.self) {
                weekdaySymbol in
                content(weekdaySymbol)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    WeekdaySymbolsView { weekdaySymbol in
        Text(weekdaySymbol)
            .font(.system(size: 12, weight: .light))
    }
}
