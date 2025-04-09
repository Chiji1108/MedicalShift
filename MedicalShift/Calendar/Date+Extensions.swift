//
//  Date+Extensions.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/04.
//

import Foundation

extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }

    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    var isWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }

    var startOfMonth: Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: self))!
    }

    func isInSameYearMonth(_ date: Date) -> Bool {
        return self.startOfMonth == date.startOfMonth
    }

    // MARK: Standalone Symbol
    enum SymbolStyle {
        case full
        case short
        case veryShort
    }

    func monthSymbol(_ style: SymbolStyle) -> String {
        switch style {
        case .full:
            return Calendar.current.standaloneMonthSymbols[self.month - 1]
        case .short:
            return Calendar.current.shortStandaloneMonthSymbols[self.month - 1]
        case .veryShort:
            return Calendar.current.veryShortStandaloneMonthSymbols[self.month - 1]
        }
    }

    func weekdaySymbol(_ style: SymbolStyle) -> String {
        switch style {
        case .full:
            return Calendar.current.standaloneWeekdaySymbols[self.weekday - 1]
        case .short:
            return Calendar.current.shortStandaloneWeekdaySymbols[self.weekday - 1]
        case .veryShort:
            return Calendar.current.veryShortStandaloneWeekdaySymbols[self.weekday - 1]
        }
    }

    // MARK: for WeekList
    var weeksInMonth: Int {
        return Calendar.current.range(of: .weekOfMonth, in: .month, for: self)!.count
    }

    // MARK: for WeekRow
    var startOfWeek: Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    var weekDates: [Date] {
        let startDate = self.startOfWeek
        let totalDays = Calendar.current.weekdaySymbols.count

        return (0..<totalDays).map { day in
            Calendar.current.date(byAdding: .day, value: day, to: startDate)!
        }
    }

    // MARK: for CalendarList
    func monthRange(in range: ClosedRange<Int>) -> [Date] {
        range.map { month in
            Calendar.current.date(byAdding: .month, value: month, to: self)!
        }
    }
}
