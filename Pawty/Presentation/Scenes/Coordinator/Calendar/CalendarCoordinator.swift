//
//  FavouriteCoordinator.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import Foundation

final class CalendarCoordinator: Coordinator {
    
    enum Screen: Routable {
        case EventDetails(EventModel)
    }
    
    @Published var navigationPath = [Screen]()
    
    init() {}
}

extension CalendarCoordinator: CalendarCoordinatorProtocol {
    func EventDetails(_ event: EventModel) {
        navigationPath.append(.EventDetails(event))
    }
}

