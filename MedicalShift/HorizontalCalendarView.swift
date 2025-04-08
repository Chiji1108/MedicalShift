//
//  HorizontalCalendarView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct HorizontalCalendarView: View {
    @Binding var selectedMonth: Date
    
    var body: some View {
        NavigationStack {
            HorizontalMonthsView(selectedMonth: $selectedMonth) { month in
                VStack(spacing: 0) {
                    WeekdaySymbolsView { weekdaySymbol in
                        Text(weekdaySymbol)
                            .font(.system(size: 12, weight: .light))
                    }
                    CalendarBodyView(month: month) { day in
                        ZStack {
                            if day.isToday {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.gray.opacity(0.2))
                            }

                            Text(day.day, format: .number.grouping(.never))
                                .padding(4)
                                .font(.system(size: 12, weight: .light))
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .frame(height: 80)
                        .opacity(day.isSameMonth(month) ? 1 : 0.4)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 8)
            }
            .navigationTitle(selectedMonth.formatted(.dateTime.month()))
            .toolbar {
                if !selectedMonth.isSameMonth(Date.now) {
                    Button("Today") {
                        withAnimation {
                            selectedMonth = Date.now
                        }
                    }
                }

                YearMonthPicker(selectedYearMonth: $selectedMonth)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedMonth = Date.now
    HorizontalCalendarView(selectedMonth: $selectedMonth)
}
