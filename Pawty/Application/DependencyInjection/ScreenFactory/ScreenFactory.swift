//
//  ScreenFactory.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import SwiftUI
import SwiftData

final class ScreenFactory: HomeCoordinatorFactory,
                           CalendarCoordinatorFactory,
                           NewsCoordinatorFactory,
                           AdoptCoordinatorFactory {
    
    
    private var modelContext: ModelContext
    private let appFactory: AppFactory

    init(appFactory: AppFactory, modelContext: ModelContext) {
        self.appFactory = appFactory
        self.modelContext = modelContext
    }
}

// MARK: - EventViewFactory

extension ScreenFactory: HomeViewFactory {
    func makeHomeView(coordinator: HomeCoordinatorProtocol) -> HomeView {
        let view = HomeView(modelContext: modelContext)
        return view
    }
}


// MARK: - FavouriteViewFactory

extension ScreenFactory: CalendarViewFactory {
    func makeCalendarView(coordinator: CalendarCoordinatorProtocol) -> CalendarView {
        let view = CalendarView(modelContext: modelContext)
        return view
    }
}

// MARK: - HomeViewFactory

extension ScreenFactory: NewsViewFactory {
    func makeNewsView(coordinator: NewsCoordinatorProtocol) -> NewsView {
        let view = NewsView()
        return view
    }
}

// MARK: - HomeViewFactory

extension ScreenFactory: AdoptViewFactory {
    func makeAdoptView(coordinator: AdoptCoordinatorProtocol) -> AdoptView {
        let view = AdoptView()
        return view
    }
}

// MARK: - MovieDetailsFactory

extension ScreenFactory: HomeDetailsViewFactory, CalendarDetailsViewFactory {
    func makeEventDetailsView(pet: PetModel) -> DetailPet {
        let view = DetailPet(imageName: "")
        return view
    }
    
    func makeCalendarDetailsView(event: EventModel) -> DetailEventView {
        let view = DetailEventView(imageName: "")
        return view
    }
}
