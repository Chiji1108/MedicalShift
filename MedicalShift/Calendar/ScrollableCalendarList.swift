//
//  ScrollableCalendarList.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct ScrollableCalendarList<Content>: View where Content: View {
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

                            if isInitialRendering && yearMonth.isInSameYearMonth(selectedYearMonth)
                            {
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

    // MARK: - Private Methods
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
        let bufferSize = 10
        let isCurrentMonthLoaded = yearMonths.contains { $0.isInSameYearMonth(selectedYearMonth) }

        guard !isCurrentMonthLoaded else { return }

        yearMonths = selectedYearMonth.monthsAround(bufferSize: bufferSize)
    }
}

#Preview {
    @Previewable @State var selectedYearMonth: Date = Date.now

    NavigationStack {
        VStack(spacing: 0) {
            WeekRow { date in
                Text(date.weekdaySymbol(.veryShort))
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(date.isWeekend ? .secondary : .primary)
            }
            .background(.gray.opacity(0.1))

            Divider()

            ScrollableCalendarList(selectedYearMonth: $selectedYearMonth) { yearMonth in
                VStack(spacing: 4) {
                    WeekRow { date in
                        if date.weekday == yearMonth.startOfMonth.weekday {
                            VStack {
                                Text(yearMonth.formatted(.dateTime.year()))
                                    .font(.system(size: 12, weight: .bold))
                                Text(yearMonth.formatted(.dateTime.month()))
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .foregroundStyle(
                                yearMonth.isInSameYearMonth(Date.now) ? .accentColor : Color.primary
                            )
                        } else {
                            Spacer()
                        }
                    }

                    WeekList(yearMonth: yearMonth) { date in
                        VStack {
                            Divider()

                            ZStack {
                                if date.isToday {
                                    Circle()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.tint)
                                }

                                Text(date.day, format: .number)
                                    .font(.system(size: 12, weight: date.isToday ? .bold : .light))
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(
                                        date.isToday
                                            ? .white : date.isWeekend ? .secondary : .primary
                                    )

                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .opacity(date.isInSameYearMonth(yearMonth) ? 1 : 0)
                    }
                }
            }
        }
        .navigationTitle(selectedYearMonth.monthSymbol(.full))
        .toolbar {
            if !selectedYearMonth.isInSameYearMonth(Date.now) {
                Button("Today") {
                    withAnimation {
                        selectedYearMonth = Date.now
                    }
                }
            }
        }
    }
}
