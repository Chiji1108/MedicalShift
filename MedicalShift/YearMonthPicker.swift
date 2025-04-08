//
//  YearMonthPicker.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/08.
//

import SwiftUI

struct YearMonthPicker: View {
    @State private var isPopoverPresened: Bool = false
    @Binding var selectedYearMonth: Date

    private var selectedYear: Binding<Int> {
        Binding {
            selectedYearMonth.year
        } set: { newValue in
            selectedYearMonth.year = newValue
        }
    }

    private var selectedMonth: Binding<Int> {
        Binding {
            selectedYearMonth.month
        } set: { newValue in
            selectedYearMonth.month = newValue
        }
    }

    var body: some View {
        Button("Select a year & month", systemImage: "calendar") {
            isPopoverPresened.toggle()
        }
        .popover(isPresented: $isPopoverPresened) {
            HStack(spacing: 0) {
                Picker("Year", selection: selectedYear) {
                    ForEach(
                        ((Date.now.year - 200)...(Date.now.year + 200)), id: \.self
                    ) { year in
                        Text(
                            Calendar.current.date(from: DateComponents(year: year))!.formatted(
                                .dateTime.year()))
                    }
                }
                .pickerStyle(.wheel)

                Picker("Month", selection: selectedMonth) {
                    ForEach(
                        1...12, id: \.self
                    ) { month in
                        Text(
                            Calendar.current.date(from: DateComponents(month: month))!.formatted(
                                .dateTime.month()))
                    }
                }
                .pickerStyle(.wheel)
            }
            .presentationCompactAdaptation(PresentationAdaptation.popover)
        }
    }
}

#Preview {
    @Previewable @State var selectedMonth: Date = Date()
    YearMonthPicker(selectedYearMonth: $selectedMonth)
}
