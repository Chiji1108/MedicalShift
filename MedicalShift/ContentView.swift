//
//  ContentView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/04.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMonth: Date? = Date.now

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
                    VStack {
                        CalendarHeaderView(month: month) {
                            VStack {
                                Text(month.formatted(.dateTime.year()))
                                    .font(.system(size: 12, weight: .bold))
                                Text(month.formatted(.dateTime.month()))
                                    .font(.system(size: 24, weight: .bold))
                            }
                        }
                        CalendarBodyView(month: month) { day, isCurrentMonth in
                            ZStack {
                                if day.isToday {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.gray.opacity(0.2))
                                }

                                Text("\(day.day)")
                                    .font(.system(size: 12, weight: .light))
                                    .frame(maxHeight: .infinity, alignment: .top)
                            }
                            .frame(height: 80)
                            .opacity(isCurrentMonth ? 1 : 0)
                        }
                    }
                }
            }
            .navigationTitle(selectedMonth?.formatted(.dateTime.month()) ?? "")
        }
    }
}

#Preview {
    ContentView()
}
