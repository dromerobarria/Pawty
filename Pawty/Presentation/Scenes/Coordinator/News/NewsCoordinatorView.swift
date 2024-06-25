//
//  NewsCoordinatorView.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import SwiftUI

struct NewsCoordinatorView: View {

    private let factory: NewsViewFactory
    @ObservedObject private var coordinator: NewsCoordinator

    init(_ coordinator: NewsCoordinator, factory: NewsViewFactory) {
        self.factory = factory
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            factory.makeNewsView(coordinator: coordinator)
                .navigationDestination(for: NewsCoordinator.Screen.self) {
                    destination($0)
                }
        }
    }

    @ViewBuilder
    private func destination(_ screen: NewsCoordinator.Screen) -> some View {
       
    }
}
