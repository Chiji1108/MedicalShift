//
//  HorizontalCalendarView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct HorizontalCalendarView: View {
    @Binding var selectedYearMonth: Date
    
    var body: some View {
        NavigationStack {
            HorizontalMonthsView(selectedYearMonth: $selectedYearMonth) { yearMonth in
                VStack(spacing: 0) {
                    WeekdaySymbolsView { weekdaySymbol in
                        Text(weekdaySymbol)
                            .font(.system(size: 12, weight: .light))
                    }
                    CalendarBodyView(yearMonth: yearMonth) { day in
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
                        .opacity(day.isSameYearMonth(yearMonth) ? 1 : 0.4)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 8)
            }
            .navigationTitle(selectedYearMonth.formatted(.dateTime.month()))
            .toolbar {
                if !selectedYearMonth.isSameYearMonth(Date.now) {
                    Button("Today") {
                        withAnimation {
                            selectedYearMonth = Date.now
                        }
                    }
                }

                YearMonthPicker(selectedYearMonth: $selectedYearMonth)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedMonth = Date.now
    HorizontalCalendarView(selectedYearMonth: $selectedMonth)
}
