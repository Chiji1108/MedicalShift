//
//  HorizontalMonthsView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct HorizontalMonthsView<Content>: View where Content: View {
    @Binding private var selectedMonth: Date
    private let dateRange: ClosedRange<Date>

    let content: (_ month: Date) -> Content
    public init(
        selectedMonth: Binding<Date>,
        in dateRange: ClosedRange<Date> = Calendar.current.date(
            byAdding: .year, value: -50, to: Date.now)!...Calendar.current.date(
                byAdding: .year, value: 50, to: Date.now)!,
        @ViewBuilder content: @escaping (_ month: Date) ->
            Content
    ) {
        self._selectedMonth = selectedMonth
        self.dateRange = dateRange
        self.content = content
    }

    private var selection: Binding<Date> {
        Binding {
            selectedMonth.startOfMonth
        } set: { newValue in
            selectedMonth = newValue
        }
    }

    var body: some View {
        TabView(selection: selection) {
            ForEach(dateRange.months, id: \.startOfMonth) { month in
                content(month)
                    .tag(month.startOfMonth)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    @Previewable @State var selectedMonth: Date = Date.now

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
