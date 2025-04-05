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

    func isInSameMonth(as date: Date) -> Bool {
        return self.startOfMonth == date.startOfMonth
    }

    var datesInCalendarMonth: [Date] {
        let startDate = self.startOfMonth.startOfWeek
        let totalDays = self.weeksInMonth * Calendar.current.weekdaySymbols.count

        return (0..<totalDays).map { day in
            Calendar.current.date(byAdding: .day, value: day, to: startDate)!
        }
    }

    func months(previous: Int, following: Int) -> [Date] {
        (-previous..<following).map { month in
            Calendar.current.date(byAdding: .month, value: month, to: self)!
        }
    }
}
