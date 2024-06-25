//
//  ScreenFactoryProtocols.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import SwiftUI

@MainActor
protocol HomeViewFactory {
    func makeHomeView(coordinator: HomeCoordinatorProtocol) -> HomeView
}


@MainActor
protocol AdoptViewFactory {
    func makeAdoptView(coordinator: AdoptCoordinatorProtocol) -> AdoptView
}

@MainActor
protocol CalendarViewFactory {
    func makeCalendarView(coordinator: CalendarCoordinatorProtocol) -> CalendarView
}


@MainActor
protocol NewsViewFactory {
    func makeNewsView(coordinator: NewsCoordinatorProtocol) -> NewsView
}


@MainActor
protocol HomeDetailsViewFactory {
    func makeEventDetailsView(
        pet: PetModel
    ) -> DetailPet
}


@MainActor
protocol CalendarDetailsViewFactory {
    func makeCalendarDetailsView(
        event: EventModel
    ) -> DetailEventView
}
