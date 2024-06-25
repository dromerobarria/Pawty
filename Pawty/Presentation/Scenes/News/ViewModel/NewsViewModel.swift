//
//  EventsViewModel.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 29-01-24.
//

import Foundation

final class NewsViewModel: ViewModel {
    @Published private(set) var state: HomeViewState
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
            Task { await retrievePets() }
        }
    }
}

private extension NewsViewModel {

    func fetchPets() async throws -> HomeViewState.ViewData {
        let pets = try await fetchPetListUseCase.execute()
        return .init(petItems: pets)
    }

    func retrievePets() async {
        do {
            let movies = try await fetchPets()
            state = .loaded(movies)
        } catch {
            state = .error("\(error.localizedDescription)")
        }
    }
}
