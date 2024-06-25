//
//  AppCoordinatorView.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import SwiftUI

struct AppCoordinatorView: View {

    private let screenFactory: ScreenFactory
    @ObservedObject private var coordinator: AppCoordinator

    init(screenFactory: ScreenFactory, coordinator: AppCoordinator) {
        self.screenFactory = screenFactory
        self.coordinator = coordinator
    }

    var body: some View {
        sceneView
            .onAppear {
                coordinator.handle(.showMain)
            }
    }

    @ViewBuilder
    private var sceneView: some View {
        switch coordinator.state {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
                .tint(.appAccent)
                .backgroundColor()
        case .main:
            MainCoordinatorView(factory: screenFactory)
        }
    }
}

