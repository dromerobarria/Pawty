import SwiftUI
import SwiftData

struct ShortCalendarView: View {
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let fullFormatter: DateFormatter

    @State private var selectedDate = Self.now
    private static var now = Date()

    
    @Query var fixtures: [EventModel]
    
//    @FetchRequest(sortDescriptors: []) var fixtures: FetchedResults<Fixture>

    init(calendar: Calendar) {
        self.calendar = calendar
        self.monthFormatter = DateFormatter(dateFormat: "MMMM YYYY", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: calendar)
        self.fullFormatter = DateFormatter(dateFormat: "MMMM dd, yyyy", calendar: calendar)
   }

    var body: some View {
        VStack {
            CalendarViewComponent(
                calendar: calendar,
                date: $selectedDate,
                content: { date in
                    ZStack {
                        Button(action: { selectedDate = date }) {
                            Text(dayFormatter.string(from: date))
                                .padding(6)
                                .foregroundColor(calendar.isDateInToday(date) ? Color.white : .primary)
                                .background(
                                    calendar.isDateInToday(date) ? Color.gray
                                    : calendar.isDate(date, inSameDayAs: selectedDate) ? .green
                                    : .clear
                                )
                                .cornerRadius(7)
                        }

                        if (dateHasFixtures(date: date)) {
                            Circle()
                                .size(CGSize(width: 5, height: 5))
                                .foregroundColor(Color.red)
                                .offset(x: CGFloat(15),
                                        y: CGFloat(35))
                        }

                        if (dateHasFixtures(date: date)) {
                            Circle()
                                .size(CGSize(width: 5, height: 5))
                                .foregroundColor(Color.blue)
                                .offset(x: CGFloat(23),
                                        y: CGFloat(35))
                        }

                        if (dateHasFixtures(date: date)) {
                            Circle()
                                .size(CGSize(width: 5, height: 5))
                                .foregroundColor(Color.green)
                                .offset(x: CGFloat(30),
                                        y: CGFloat(35))
                        }
                    }
                },
                trailing: { date in
                    Text(dayFormatter.string(from: date))
                        .foregroundColor(.secondary)
                },
                header: { date in
                    Text(weekDayFormatter.string(from: date)).fontWeight(.bold)
                },
                title: { date in
                    HStack {

                        Button {
                            guard let newDate = calendar.date(
                                byAdding: .month,
                                value: -1,
                                to: selectedDate
                            ) else {
                                return
                            }

                            selectedDate = newDate

                        } label: {
                            Label(
                                title: { Text("Previous") },
                                icon: {
                                    Image(systemName: "chevron.left.circle.fill")
                                        .foregroundColor(.black)
                                        .font(.title)

                                }
                            )
                            .labelStyle(IconOnlyLabelStyle())
                            .padding(.horizontal)
                        }

                        Spacer()

                        Text(monthFormatter.string(from: date))
                            .font(.title)
                            .padding(2)

                        Spacer()

                        Button {
                            guard let newDate = calendar.date(
                                byAdding: .month,
                                value: 1,
                                to: selectedDate
                            ) else {
                                return
                            }

                            selectedDate = newDate

                        } label: {
                            Label(
                                title: { Text("Next") },
                                icon: {
                                    Image(systemName: "chevron.right.circle.fill")
                                        .foregroundColor(.black)
                                        .font(.title)

                                }
                            )
                            .labelStyle(IconOnlyLabelStyle())
                            .padding(.horizontal)
                        }
                    }.padding(.bottom, 10)
                }
            )
            .equatable()
        }
        .padding()
    }

    func dateHasFixtures(date: Date) -> Bool {

        for fixture in fixtures {
            if calendar.isDate(date, inSameDayAs: fixture.date ?? Date()) {
                return true
            }
        }

        return false
    }
}

// MARK: - Component

public struct CalendarViewComponent<Day: View, Header: View, Title: View, Trailing: View>: View {
    // Injected dependencies
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title

    // Constants
    private let daysInWeek = 7

    @Query var fixtures: [EventModel]
//    @FetchRequest var fixtures: FetchedResults<Fixture>

    public init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title
    ) {
        self.calendar = calendar
        self._date = date
        self.content = content
        self.trailing = trailing
        self.header = header
        self.title = title

//        _fixtures = FetchRequest<Fixture>(sortDescriptors: [],
//            predicate: NSPredicate(
//                format: "date >= %@ && date <= %@",
//                Calendar.current.startOfDay(for: date.wrappedValue) as CVarArg,
//                Calendar.current.startOfDay(for: date.wrappedValue + 86400) as CVarArg))
    }

    public var body: some View {

        let month = date.startOfMonth(using: calendar)
        let days = makeDays()

        VStack {

            Section(header: title(month)) { }

            VStack {

                LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                    ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                }

                Divider()

                LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                    ForEach(days, id: \.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(date)
                        } else {
                            trailing(date)
                        }
                    }
                }
            }
            .frame(height: days.count == 42 ? 300 : 270)
            .background(Color.white)
//            .clipShape(ClubsListsShape(corner: .bottomLeft, radii: 35))
//            .clipShape(ClubsListsShape(corner: .bottomRight, radii: 35))
//            .clipShape(ClubsListsShape(corner: .topLeft, radii: 35))
//            .clipShape(ClubsListsShape(corner: .topRight, radii: 35))
            .shadow(radius: 5)
            .padding(.bottom, 10)

//            List(fixtures) { fixture in
//                NavigationLink {
//                    FixtureReadView(fixture: fixture)
//                } label: {
//                    FixtureListItem(fixture: fixture)
//                }
//            }.listStyle(.plain)
        }
    }
}

// MARK: - Conformances

extension CalendarViewComponent: Equatable {
    public static func == (lhs: CalendarViewComponent<Day, Header, Title, Trailing>, rhs: CalendarViewComponent<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

// MARK: - Helpers

private extension CalendarViewComponent {
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }

        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}

private extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]

        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }

            guard date < dateInterval.end else {
                stop = true
                return
            }

            dates.append(date)
        }

        return dates
    }

    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

private extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}
