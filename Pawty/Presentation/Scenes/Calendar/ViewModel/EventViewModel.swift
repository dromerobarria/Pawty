import Foundation

final class EventViewModel: ViewModel {
    @Published private(set) var state: EventViewState
    private let fetchPetListUseCase: FetchPetListUseCase

    init(
        fetchPetListUseCase: FetchPetListUseCase
    ) {
        state = .idle
        self.fetchPetListUseCase = fetchPetListUseCase
    }

    func handle(_ event: HomeViewEvent) {
        switch event {
        case .onAppear:
            Task { await retrieveEvents() }
        }
    }
}

private extension EventViewModel {

    func fetcheEvents() async throws -> EventViewState.ViewData {
        let events = try await fetchPetListUseCase.executeEvents()
        return .init(eventsItems: events)
    }

    func retrieveEvents() async {
        do {
            let events = try await fetcheEvents()
            state = .loaded(events)
        } catch {
            state = .error("\(error.localizedDescription)")
        }
    }
    
}
