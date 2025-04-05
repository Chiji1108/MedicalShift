//
//  ClosedRange+Extensions.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/04.
//

import Foundation

extension ClosedRange where Bound == Date {
    var months: [Date] {
        let monthCount =
            Calendar.current.dateComponents(
                [.month],
                from: lowerBound.startOfMonth,
                to: upperBound
            ).month ?? 0

        return (0...monthCount).map { monthOffset in
            Calendar.current.date(
                byAdding: .month,
                value: monthOffset,
                to: lowerBound.startOfMonth
            )!
        }
    }
}
