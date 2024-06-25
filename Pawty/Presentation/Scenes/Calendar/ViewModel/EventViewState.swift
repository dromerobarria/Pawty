enum EventViewEvent {
    case onAppear
}

enum EventViewState: Equatable {
    case idle
    case loading
    case error(String)
    case loaded(ViewData)
    
    struct ViewData: Equatable {
        var eventsItems: [EventModel]
    }
}
