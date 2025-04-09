import SwiftUI

enum CalendarScrollDirection {
    case vertical
    case horizontal
}

struct CalendarList<Content>: View where Content: View {
    @Binding var selectedYearMonth: Date
    let content: (_ yearMonth: Date) -> Content
    let direction: CalendarScrollDirection

    @State private var yearMonths: [Date] = []
    @State private var isInitialRendering = true

    public init(
        selectedYearMonth: Binding<Date>,
        direction: CalendarScrollDirection = .vertical,
        @ViewBuilder content: @escaping (_ yearMonth: Date) -> Content
    ) {
        self._selectedYearMonth = selectedYearMonth
        self.content = content
        self.direction = direction
    }

    var body: some View {
        Group {
            switch direction {
            case .vertical:
                verticalLayout
            case .horizontal:
                horizontalLayout
            }
        }
        .onAppear {
            loadMonthsIfNeeded()
        }
        .onChange(of: selectedYearMonth) {
            loadMonthsIfNeeded()
        }
        .onDisappear {
            isInitialRendering = true
        }
    }

    private var verticalLayout: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(yearMonths, id: \.startOfMonth) { yearMonth in
                    content(yearMonth)
                        .onAppear {
                            appendMonthsIfNeeded(for: yearMonth)
                            if isInitialRendering, yearMonth.isInSameYearMonth(selectedYearMonth) {
                                isInitialRendering = false
                            }
                        }
                }
            }
            .scrollTargetLayout()
        }
        .defaultScrollAnchor(.center)
        .scrollPosition(id: isInitialRendering ? initialScrolledID : scrolledID, anchor: .center)
    }

    private var horizontalLayout: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(yearMonths, id: \.startOfMonth) { yearMonth in
                        content(yearMonth)
                            .onAppear {
                                appendMonthsIfNeeded(for: yearMonth)
                                if isInitialRendering,
                                    yearMonth.isInSameYearMonth(selectedYearMonth)
                                {
                                    isInitialRendering = false
                                }
                            }
                            .frame(width: proxy.size.width)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .defaultScrollAnchor(.center)
            .scrollPosition(
                id: isInitialRendering ? initialScrolledID : scrolledID, anchor: .center)
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

    private func loadMonthsIfNeeded() {
        let bufferSize = 10
        let isCurrentMonthLoaded = yearMonths.contains { $0.isInSameYearMonth(selectedYearMonth) }

        guard !isCurrentMonthLoaded else { return }

        yearMonths = selectedYearMonth.monthsAround(bufferSize: bufferSize)
    }

    private func appendMonthsIfNeeded(for yearMonth: Date) {
        if yearMonths.first == yearMonth,
            let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: yearMonth)
        {
            yearMonths.insert(previousMonth, at: 0)
        }

        if yearMonths.last == yearMonth,
            let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: yearMonth)
        {
            yearMonths.append(nextMonth)
        }
    }
}

#Preview("Scrollable Calendar") {
    @Previewable @State var selectedYearMonth: Date = Date.now

    NavigationStack {
        VStack(spacing: 0) {
            // MARK: Weekday Symbols
            WeekRow { date in
                Text(date.weekdaySymbol(.veryShort))
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(date.isWeekend ? .secondary : .primary)
            }
            .background(.gray.opacity(0.1))

            Divider()

            CalendarList(selectedYearMonth: $selectedYearMonth) { yearMonth in
                VStack(spacing: 4) {
                    // MARK: YearMonth Symbol
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

                    // MARK: Calendar Body
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
                        .frame(height: 96)
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

#Preview("Paged Calendar") {
    @Previewable @State var selectedYearMonth: Date = Date.now

    NavigationStack {
        CalendarList(selectedYearMonth: $selectedYearMonth, direction: .horizontal) { yearMonth in
            VStack(spacing: 0) {
                // MARK: Weekday Symbols
                WeekRow { date in
                    Text(date.weekdaySymbol(.veryShort))
                        .font(.system(size: 12, weight: .light))
                }

                // MARK: Calendar Body
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
