//
//  PagedCalendarList.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct PagedCalendarList<Content>: View where Content: View {
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
        let monthRange = -3...3
        let isCurrentMonthLoaded = yearMonths.contains { $0.isInSameYearMonth(selectedYearMonth) }
        
        guard !isCurrentMonthLoaded else { return }
        
        yearMonths = selectedYearMonth.monthRange(in: monthRange)
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
        PagedCalendarList(selectedYearMonth: $selectedYearMonth) { yearMonth in
            VStack(spacing: 0) {
                WeekRow { date in
                    Text(date.weekdaySymbol(.veryShort))
                        .font(.system(size: 12, weight: .light))
                }

                WeekList(yearMonth: yearMonth) { date in
                    ZStack {
                        if date.isToday {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.gray.opacity(0.2))
                        }

                        Text(date.day, format: .number)
                            .padding(4)
                            .font(.system(size: 12, weight: .light))
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                    .frame(height: 80)
                    .opacity(date.isInSameYearMonth(yearMonth) ? 1 : 0.4)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 8)
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
