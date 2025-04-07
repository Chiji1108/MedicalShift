//
//  HorizontalMonthsView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct HorizontalMonthsView<Content>: View where Content: View {
    @Binding private var selectedMonth: Date

    @State private var months: [Date] = []

    let content: (_ month: Date) -> Content
    public init(
        selectedMonth: Binding<Date>,
        @ViewBuilder content: @escaping (_ month: Date) ->
            Content
    ) {
        self._selectedMonth = selectedMonth
        self.content = content
    }

    private var selection: Binding<Date> {
        Binding {
            selectedMonth.startOfMonth
        } set: { newValue in
            selectedMonth = newValue
        }
    }
    
    private func loadMonths() {
        if !months.contains(where: { $0.isSameMonth(selectedMonth) }) {
            months =
                selectedMonth.months(previous: -3, following: 3)
        }
    }


    var body: some View {
        TabView(selection: selection) {
            ForEach(months, id: \.startOfMonth) { month in
                content(month)
                    .tag(month.startOfMonth)
                    .onAppear {
                        if months.first == month {
                            months.insert(
                                Calendar.current.date(byAdding: .month, value: -1, to: month)!,
                                at: 0
                            )
                        }

                        if months.last == month {
                            months.append(
                                Calendar.current.date(byAdding: .month, value: 1, to: month)!,
                            )
                        }
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            loadMonths()
        }
        .onChange(of: selectedMonth) {
            loadMonths()
        }
    }
}

#Preview {
    @Previewable @State var selectedMonth: Date = Date.now

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

            DatePicker("Select a month", selection: $selectedMonth, displayedComponents: .date)
                .labelsHidden()
        }
    }
}
