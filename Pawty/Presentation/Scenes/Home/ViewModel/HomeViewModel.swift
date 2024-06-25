import Foundation
import os

final class HomeViewModel: ViewModel {
    @Published private(set) var state: HomeViewState
    private let fetchPetListUseCase: FetchPetListUseCase
    let app = OSLog(subsystem: "com.Pawty.app", category: "HomeViewModel")
    
    init(
        fetchPetListUseCase: FetchPetListUseCase
    ) {
        os_log("▶️ Start playing", log: app, type: .info)
        state = .idle
        self.fetchPetListUseCase = fetchPetListUseCase
    }

    func handle(_ event: HomeViewEvent) {
        switch event {
        case .onAppear:
            Task { await retrievePets() }
        }
    }
}

private extension HomeViewModel {

    func fetchPets() async throws -> HomeViewState.ViewData {
        os_log("▶️ Pause playing", log: app, type: .info)
        let pets = try await fetchPetListUseCase.execute()
        return .init(petItems: pets)
    }

    func retrievePets() async {
        do {
            let pets = try await fetchPets()
            state = .loaded(pets)
        } catch {
            state = .error("\(error.localizedDescription)")
        }
    }
    
}
