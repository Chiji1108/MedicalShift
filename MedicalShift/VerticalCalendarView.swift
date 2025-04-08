//
//  VerticalCalendarView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct VerticalCalendarView: View {
    @Binding var selectedYearMonth: Date

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                WeekdaySymbolsView { weekdaySymbol in
                    Text(weekdaySymbol)
                        .font(.system(size: 12, weight: .light))
                }
                .background(.ultraThinMaterial)

                Divider()

                VerticalMonthsView(selectedYearMonth: $selectedYearMonth) { yearMonth in
                    VStack(spacing: 4) {
                        CalendarHeaderView(yearMonth: yearMonth) {
                            VStack {
                                Text(yearMonth.formatted(.dateTime.year()))
                                    .font(.system(size: 12, weight: .bold))
                                Text(yearMonth.formatted(.dateTime.month()))
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .foregroundStyle(
                                yearMonth.isSameYearMonth(Date.now) ? .accentColor : Color.primary)
                        }
                        CalendarBodyView(yearMonth: yearMonth) { day in
                            VStack {
                                Divider()

                                ZStack {
                                    if day.isToday {
                                        Circle()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(.tint)
                                    }

                                    Text(day.day, format: .number.grouping(.never))
                                        .font(.system(size: 12, weight: day.isToday ? .bold : .light))
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(day.isToday ? .white : .primary)

                                }
                                .frame(maxHeight: .infinity, alignment: .top)
                            }
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .opacity(day.isSameYearMonth(yearMonth) ? 1 : 0)
                        }
                    }
                }
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
    VerticalCalendarView(selectedYearMonth: $selectedMonth)
}
