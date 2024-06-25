//
//  FavouriteCoordinatorView.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import SwiftUI

struct CalendarCoordinatorView: View {

    private let factory: CalendarViewFactory
    @ObservedObject private var coordinator: CalendarCoordinator

    init(_ coordinator: CalendarCoordinator, factory: CalendarViewFactory) {
        self.factory = factory
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            factory.makeCalendarView(coordinator: coordinator)
                .navigationDestination(for: CalendarCoordinator.Screen.self) {
                    destination($0)
                }
        }
    }

    @ViewBuilder
    private func destination(_ screen: CalendarCoordinator.Screen) -> some View {
       
    }
}
