//
//  VerticalMonthsView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct VerticalMonthsView<Content>: View where Content: View {
    @Binding var selectedMonth: Date?

    private let dateRange: ClosedRange<Date>
    let content: (_ month: Date) -> Content

    public init(
        selectedMonth: Binding<Date?>,
        dateRange: ClosedRange<Date> = Calendar.current.date(
            byAdding: .year, value: -50, to: Date.now)!...Calendar.current.date(
                byAdding: .year, value: 50, to: Date.now)!,
        @ViewBuilder content: @escaping (_ month: Date) -> Content
    ) {
        self._selectedMonth = selectedMonth
        self.dateRange = dateRange
        self.content = content
    }

    var scrollPosition: Binding<Date?> {
        Binding {
            selectedMonth?.startOfMonth
        } set: { newValue in
            selectedMonth = newValue
        }
    }

    var body: some View {


            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(dateRange.months, id: \.startOfMonth) { month in
                        content(month)
                    }
                }
                .scrollTargetLayout()
            }
            .defaultScrollAnchor(.center)
            .scrollPosition(id: scrollPosition, anchor: .center)
            // .onAppear {
            //     scrollPosition = Date.now.startOfMonth
            // }


        // .scrollPosition(initialAnchor: .center)
        // .toolbar {
        //     Button {
        //         proxy.scrollTo(Date.now.startOfMonth)
        //     } label: {
        //         Text("Today")
        //     }
        // }

    }
}

#Preview {
    @Previewable @State var selectedMonth: Date? = Date.now

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
        .navigationTitle(selectedMonth?.formatted(.dateTime.month()) ?? "")
    }
}
