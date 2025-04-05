//
//  HorizontalCalendarView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct HorizontalCalendarView: View {
    @State private var selectedMonth: Date = Date.now
    
    var body: some View {
        NavigationStack {
            HorizontalMonthsView(selectedMonth: $selectedMonth) { month in
                ScrollView {
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
                                .font(.system(size: 12, weight: .light))
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .frame(height: 80)
                        .opacity(day.isInSameMonth(as: month) ? 1 : 0.4)
                    }
                }
                .padding(.horizontal, 8)
            }
            .navigationTitle(selectedMonth.formatted(.dateTime.month()))
            .toolbar {
                if !selectedMonth.isInSameMonth(as: Date.now) {
                    Button("Today") {
                        withAnimation {
                            selectedMonth = Date.now
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HorizontalCalendarView()
}
