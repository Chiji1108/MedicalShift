//
//  VerticalMonthsView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct VerticalMonthsView<Content>: View where Content: View {
    @Binding var selectedYearMonth: Date
    let content: (_ yearMonth: Date) -> Content

    @State private var yearMonths: [Date] = []
    @State private var isInitialRendering = true

    public init(
        selectedYearMonth: Binding<Date>,
        @ViewBuilder content: @escaping (_ yearMonth: Date) -> Content
    ) {
        self._selectedYearMonth = selectedYearMonth
        self.content = content
    }

    private var scrolledID: Binding<Date?> {
        Binding {
            selectedYearMonth.startOfMonth
        } set: { newValue in
            if let newValue {
                selectedYearMonth = newValue
            }
        }
    }

    private var initialScrolledID: Binding<Date?> {
        Binding(get: { nil }, set: { _ in })
    }

    private func loadMonths() {
        let buffer = 10
        if !yearMonths.contains(where: { $0.isSameYearMonth(selectedYearMonth) }) {
            yearMonths =
                selectedYearMonth.months(prev: -buffer, next: buffer)
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(yearMonths, id: \.startOfMonth) { yearMonth in
                    content(yearMonth)
                        .onAppear {
                            if yearMonths.first == yearMonth {
                                yearMonths.insert(
                                    Calendar.current.date(
                                        byAdding: .month, value: -1, to: yearMonth)!,
                                    at: 0
                                )
                            }

                            if yearMonths.last == yearMonth {
                                yearMonths.append(
                                    Calendar.current.date(
                                        byAdding: .month, value: 1, to: yearMonth)!
                                )
                            }

                            if isInitialRendering && yearMonth.isSameYearMonth(selectedYearMonth) {
                                isInitialRendering = false
                            }
                        }
                }
            }
            .scrollTargetLayout()
        }
        .defaultScrollAnchor(.center)
        .scrollPosition(id: isInitialRendering ? initialScrolledID : scrolledID, anchor: .center)
        .onAppear {
            loadMonths()
        }
        .onChange(of: selectedYearMonth) {
            loadMonths()
        }
        .onDisappear {
            isInitialRendering = true
        }
    }
}

#Preview {
    @Previewable @State var selectedYearMonth: Date = Date.now

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
                    MonthSymbolView(yearMonth: yearMonth) {
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
                                    .foregroundStyle(
                                        day.isToday ? .white : day.isWeekend ? .secondary : .primary
                                    )

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
        .navigationTitle(selectedYearMonth.monthSymbol(.full))
        .toolbar {
            if !selectedYearMonth.isSameYearMonth(Date.now) {
                Button("Today") {
                    withAnimation {
                        selectedYearMonth = Date.now
                    }
                }
            }
        }
    }
}
