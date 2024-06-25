//
//  AppCoordinator.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import Foundation

@MainActor
final class AppCoordinator: ObservableObject {

    enum State {
        case idle
        case loading
        case main
    }

    enum Action {
        case showMain
    }

    @Published private(set) var state: State

    init(
    ) {
        state = .idle
    }

    func handle(_ action: Action) {
        switch action {
        case .showMain:
            state = .main
        }
    }
}
