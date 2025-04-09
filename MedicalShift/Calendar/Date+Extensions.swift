//
//  Date+Extensions.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/04.
//

import Foundation

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var day: Int {
        Calendar.current.component(.day, from: self)
    }

    var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }

    var weekOfMonth: Int {
        Calendar.current.component(.weekOfMonth, from: self)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var isWeekend: Bool {
        Calendar.current.isDateInWeekend(self)
    }

    var startOfMonth: Date {
        Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: self))!
    }

    func isInSameYearMonth(_ date: Date) -> Bool {
        self.startOfMonth == date.startOfMonth
    }

    // MARK: - Standalone Symbol
    enum SymbolStyle {
        case full
        case short
        case veryShort
    }

    func monthSymbol(_ style: SymbolStyle) -> String {
        switch style {
        case .full:
            Calendar.current.standaloneMonthSymbols[self.month - 1]
        case .short:
            Calendar.current.shortStandaloneMonthSymbols[self.month - 1]
        case .veryShort:
            Calendar.current.veryShortStandaloneMonthSymbols[self.month - 1]
        }
    }

    func weekdaySymbol(_ style: SymbolStyle) -> String {
        switch style {
        case .full:
            Calendar.current.standaloneWeekdaySymbols[self.weekday - 1]
        case .short:
            Calendar.current.shortStandaloneWeekdaySymbols[self.weekday - 1]
        case .veryShort:
            Calendar.current.veryShortStandaloneWeekdaySymbols[self.weekday - 1]
        }
    }

    // MARK: - for WeekRow
    var startOfWeek: Date {
        Calendar.current.date(
            from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    var weekDates: [Date] {
        let startDate = self.startOfWeek
        let totalDays = Calendar.current.weekdaySymbols.count

        return (0..<totalDays).compactMap { day in
            Calendar.current.date(byAdding: .day, value: day, to: startDate)
        }
    }

    // MARK: - for WeekList
    var weeksInMonth: Int {
        Calendar.current.range(of: .weekOfMonth, in: .month, for: self)!.count
    }

    // MARK: - for CalendarList
    func monthsAround(bufferSize: Int) -> [Date] {
        (-bufferSize...bufferSize).compactMap { month in
            Calendar.current.date(byAdding: .month, value: month, to: self)
        }
    }
}
