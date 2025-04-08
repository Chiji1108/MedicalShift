//
//  Date+Extensions.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/04.
//

import Foundation

extension Date {
    var startOfMonth: Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: self))!
    }

    var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
        set {
            self = Calendar.current.date(from: DateComponents(year: newValue, month: self.month))!
        }
    }

    var month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
        set {
            self = Calendar.current.date(from: DateComponents(year: self.year, month: newValue))!
        }
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

    var startOfWeek: Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    var weeksInMonth: Int {
        return Calendar.current.range(of: .weekOfMonth, in: .month, for: self)!.count
    }

    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    func isSameYearMonth(_ date: Date) -> Bool {
        return self.startOfMonth == date.startOfMonth
    }

    var calnedarDates: [Date] {
        let startDate = self.startOfMonth.startOfWeek
        let totalDays = self.weeksInMonth * Calendar.current.weekdaySymbols.count

        return (0..<totalDays).map { day in
            Calendar.current.date(byAdding: .day, value: day, to: startDate)!
        }
    }

    func months(prev: Int, next: Int) -> [Date] {
        (prev...next).map { month in
            Calendar.current.date(byAdding: .month, value: month, to: self)!
        }
    }
}
