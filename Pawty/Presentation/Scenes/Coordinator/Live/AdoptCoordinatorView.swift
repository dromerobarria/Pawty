//
//  LiveCoordinatorLive.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import SwiftUI

struct AdoptCoordinatorView: View {

    private let factory: AdoptViewFactory
    @ObservedObject private var coordinator: AdoptCoordinator

    init(_ coordinator: AdoptCoordinator, factory: AdoptViewFactory) {
        self.factory = factory
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            factory.makeAdoptView(coordinator: coordinator)
                .navigationDestination(for: AdoptCoordinator.Screen.self) {
                    destination($0)
                }
        }
    }

    @ViewBuilder
    private func destination(_ screen: AdoptCoordinator.Screen) -> some View {
       
    }
}
