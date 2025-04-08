//
//  HorizontalMonthsView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct HorizontalMonthsView<Content>: View where Content: View {
    @Binding private var selectedYearMonth: Date

    @State private var yearMonths: [Date] = []

    let content: (_ yearMonth: Date) -> Content
    public init(
        selectedYearMonth: Binding<Date>,
        @ViewBuilder content: @escaping (_ yearMonth: Date) ->
            Content
    ) {
        self._selectedYearMonth = selectedYearMonth
        self.content = content
    }

    private var selection: Binding<Date> {
        Binding {
            selectedYearMonth.startOfMonth
        } set: { newValue in
            selectedYearMonth = newValue
        }
    }
    
    private func loadMonths() {
        let buffer = 3
        if !yearMonths.contains(where: { $0.isSameYearMonth(selectedYearMonth) }) {
            yearMonths =
                selectedYearMonth.months(prev: -buffer, next: buffer)
        }
    }


    var body: some View {
        TabView(selection: selection) {
            ForEach(yearMonths, id: \.startOfMonth) { yearMonth in
                content(yearMonth)
                    .tag(yearMonth.startOfMonth)
                    .onAppear {
                        if yearMonths.first == yearMonth {
                            yearMonths.insert(
                                Calendar.current.date(byAdding: .month, value: -1, to: yearMonth)!,
                                at: 0
                            )
                        }

                        if yearMonths.last == yearMonth {
                            yearMonths.append(
                                Calendar.current.date(byAdding: .month, value: 1, to: yearMonth)!,
                            )
                        }
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            loadMonths()
        }
        .onChange(of: selectedYearMonth) {
            loadMonths()
        }
    }
}

#Preview {
    @Previewable @State var selectedYearMonth: Date = Date.now

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
