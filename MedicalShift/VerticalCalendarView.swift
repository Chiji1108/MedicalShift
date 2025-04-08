//
//  VerticalCalendarView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct VerticalCalendarView: View {
    @Binding var selectedMonth: Date

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                WeekdaySymbolsView { weekdaySymbol in
                    Text(weekdaySymbol)
                        .font(.system(size: 12, weight: .light))
                }
                .background(.ultraThinMaterial)

                Divider()

                VerticalMonthsView(selectedMonth: $selectedMonth) { month in
                    VStack(spacing: 4) {
                        CalendarHeaderView(month: month) {
                            VStack {
                                Text(month.formatted(.dateTime.year()))
                                    .font(.system(size: 12, weight: .bold))
                                Text(month.formatted(.dateTime.month()))
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .foregroundStyle(
                                month.isSameMonth(Date.now) ? .accentColor : Color.primary)
                        }
                        CalendarBodyView(month: month) { day in
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
                            .opacity(day.isSameMonth(month) ? 1 : 0)
                        }
                    }
                }
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
    VerticalCalendarView(selectedMonth: $selectedMonth)
}
