//
//  VerticalMonthsView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct VerticalMonthsView<Content>: View where Content: View {
    @Binding var selectedMonth: Date

    let content: (_ month: Date) -> Content

    @State private var months: [Month] = []

    @State private var isInitialRendering = true

    public init(
        selectedMonth: Binding<Date>,
        @ViewBuilder content: @escaping (_ month: Date) -> Content
    ) {
        self._selectedMonth = selectedMonth
        self.content = content
    }

    private var scrolledID: Binding<Month.ID?> {
        Binding {
            selectedMonth.startOfMonth
        } set: { newValue in
            if let newValue {
                selectedMonth = newValue
            }
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(months) { month in
                    content(month.date)
                        .onAppear {
                            if months.first == month {
                                months.insert(
                                    Month(date: Calendar.current.date(byAdding: .month, value: -1, to: month.date)!),
                                    at: 0
                                )
                            }

                            if months.last == month {
                                months.append(
                                    Month(date: Calendar.current.date(byAdding: .month, value: 1, to: month.date)!),
                                )
                            }

                            if isInitialRendering && month.id == selectedMonth.startOfMonth {
                                isInitialRendering = false
                                // Glitchy
//                                selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth)!
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//                                    selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth)!
//                                }
                            }
                        }
                }
            }
            .scrollTargetLayout()
        }
        .defaultScrollAnchor(.center)
        .scrollPosition(id: scrolledID, anchor: .center)
        .onAppear {
            months =
                (Calendar.current.date(
                    byAdding: .month, value: -10, to: selectedMonth)!...Calendar.current.date(
                    byAdding: .month, value: 10, to: selectedMonth)!).months.map { Month(date: $0) }
        }
        .onDisappear {
            isInitialRendering = true
        }
        .onChange(of: selectedMonth) {
            if !months.contains(where: { $0.id == selectedMonth.startOfMonth }) {
                months =
                    (Calendar.current.date(
                        byAdding: .month, value: -10, to: selectedMonth)!...Calendar.current.date(
                        byAdding: .month, value: 10, to: selectedMonth)!).months.map { Month(date: $0) }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedMonth: Date = Date.now

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
                            month.isInSameMonth(as: Date.now) ? .accentColor : Color.primary)
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
                        .opacity(day.isInSameMonth(as: month) ? 1 : 0)
                    }
                }
            }
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

            DatePicker("Select a month", selection: $selectedMonth, displayedComponents: .date)
                .labelsHidden()
        }
    }
}
